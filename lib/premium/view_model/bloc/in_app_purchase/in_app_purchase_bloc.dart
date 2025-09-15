// in_app_purchase_cubit.dart
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as dio_instance;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_enhancer_app/main.dart';
import 'package:image_enhancer_app/service/in_app_purchase/in_app_purchase_subscription_bloc.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/snackbar_extension.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:intl/intl.dart';
import 'package:equatable/equatable.dart';

class DioClient {
  static final dio_instance.Dio _dio = dio_instance.Dio();
  static dio_instance.Dio get instance => _dio;
}

class InAppPurchaseState extends Equatable {
  final bool isInitialized;
  final bool isPurchasing;
  final bool purchasePending;
  final String queryProductError;
  final List<ProductDetails> availableProducts;
  final List<PurchaseDetails> purchases;

  const InAppPurchaseState({
    this.isInitialized = false,
    this.isPurchasing = false,
    this.purchasePending = false,
    this.queryProductError = '',
    this.availableProducts = const [],
    this.purchases = const []
  });

  InAppPurchaseState copyWith({
    bool? isInitialized,
    bool? isPurchasing,
    bool? purchasePending,
    String? queryProductError,
    List<ProductDetails>? availableProducts,
    List<PurchaseDetails>? purchases,
  }) {
    return InAppPurchaseState(
      isInitialized: isInitialized ?? this.isInitialized,
      isPurchasing: isPurchasing ?? this.isPurchasing,
      purchasePending: purchasePending ?? this.purchasePending,
      queryProductError: queryProductError ?? this.queryProductError,
      availableProducts: availableProducts ?? this.availableProducts,
      purchases: purchases ?? this.purchases,
    );
  }

  @override
  List<Object?> get props => [isInitialized, isPurchasing, purchasePending, queryProductError, availableProducts, purchases];
}

class InAppPurchaseBloc extends Cubit<InAppPurchaseState> {
  final InAppPurchase _iap = InAppPurchase.instance;
  late final StreamSubscription<List<PurchaseDetails>> _subscription;

  Completer<void>? _restoreCompleter;

  InAppPurchaseBloc() : super(const InAppPurchaseState()) {
    initFunction();
  }

  static const Set<String> iosProductIds = {
    'com.devsrank.pixeliftweekly.app',
    'com.devsrank.pixeliftyearly.app'
  };

  void initFunction() {
    if (!state.isInitialized) {
      final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
      _subscription = purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
        _purchaseUpdates(purchaseDetailsList);
      }, onDone: () {
        log("On Done Called");
        _subscription.cancel();
      }, onError: (Object error) {
        log("Purchase Stream Error: $error");
      }
      );
      _setupIOSDelegate();
      getProducts();
      emit(state.copyWith(isInitialized: true));
    }
  }

  void _setupIOSDelegate() {
    if (Platform.isIOS) {
      final platform = InAppPurchasePlatform.instance;

      if (platform is InAppPurchaseStoreKitPlatform) {
        final addition = InAppPurchaseStoreKitPlatformAddition();

        addition.setDelegate(ExamplePaymentQueueDelegate());
      } else {
        print('Platform instance is not StoreKit.');
      }
    }
  }

  Future<void> getProducts() async {
    try {
      final isAvailable = await _iap.isAvailable();
      if (!isAvailable) {
        emit(state.copyWith(queryProductError: "Store unavailable"));
        return;
      }

      final response = await _iap.queryProductDetails(iosProductIds);

      if (response.error != null || response.productDetails.isEmpty) {
        emit(state.copyWith(queryProductError: "No products found"));
        return;
      }

      final sorted = response.productDetails..sort((a, b) {
        const order = {
          'com.devsrank.pixeliftyearly.app': 0,
          'com.devsrank.pixeliftweekly.app': 1
        };
        return (order[a.id] ?? 4).compareTo(order[b.id] ?? 4);
      });

      emit(state.copyWith(availableProducts: sorted, isPurchasing: false));
    } catch (e) {
      emit(state.copyWith(queryProductError: "Failed to load products"));
    }
  }

  void _purchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    bool hasValidPurchase = false;
    bool hasRestoredPurchase = false;
    bool hasPendingTransactions = false; // Track if there are still pending transactions
    PurchaseDetails? product;

    for (var purchaseDetails in purchaseDetailsList) {
      emit(state.copyWith(purchases: [...state.purchases, ...[purchaseDetails]]));

      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          log("pending");
          hasPendingTransactions = true;
          emit(state.copyWith(purchasePending: true));
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          bool isValid = await _validatePurchase(purchaseDetails);
          log("restored");
          if (isValid) {
            product = purchaseDetails;
            hasValidPurchase = true;
          }

          if (purchaseDetails.status == PurchaseStatus.restored) {
            log("restored");
            hasRestoredPurchase = true;
          }
          break;

        case PurchaseStatus.error:
          log("error");
          _handleError(purchaseDetails.error?.message ?? "Unknown error");
          emit(state.copyWith(isPurchasing: false));
          break;

        case PurchaseStatus.canceled:
          log("Purchase was canceled, but waiting for other transactions.");
          emit(state.copyWith(isPurchasing: false));
          break;
      }

      if (purchaseDetails.pendingCompletePurchase) {
        log("in app purchase completed");
        await _iap.completePurchase(purchaseDetails);
        hasPendingTransactions = true; // Wait for completion
      }
    }

    // Ensure restore process completes
    if (_restoreCompleter != null && hasRestoredPurchase) {
      log("Completing restore process...");
      _restoreCompleter!.complete(); // Only complete if a restore actually happened
    }

    // Ensure the user's premium status is updated
    if (hasValidPurchase) {
      await _handlePremium();
    }  else {
      await _handleFree();
    }

    // Only turn off spinners when no more pending transactions
    if (!hasPendingTransactions && _restoreCompleter == null) {
      emit(state.copyWith(purchasePending: false, isPurchasing: false));
    }
  }

  Future<void> purchasingProduct(ProductDetails productDetails) async {
    try {
      emit(state.copyWith(isPurchasing: true));
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      emit(state.copyWith(isPurchasing: false));
      _handleError(e.toString());
    }
  }

  Future<bool> restorePurchases() async {
    emit(state.copyWith(isPurchasing: true));
    bool restored = false;
    _restoreCompleter = Completer();

    try {
      await _iap.restorePurchases();
      await _restoreCompleter!.future.timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          _restoreCompleter?.complete();
        },
      );

      restored = state.purchases.any((p) => p.status == PurchaseStatus.restored);
    } catch (e) {
      _handleError("Restore failed");
    } finally {
      emit(state.copyWith(isPurchasing: false));
      _restoreCompleter = null;
    }

    return restored;
  }

  Future<void> _handleFree() async {
    log('handleFree');

  }

  Future<void> _handlePremium() async {
    materialAppKey.currentContext?.read<InAppPurchaseSubscriptionBloc>().handlePremiumSubscription();
    log('handlePremium');
  }

  void _handleError(String msg) {
    materialAppKey.currentContext?.showSnackBar(msg: msg);
  }

  Future<bool> _validatePurchase(PurchaseDetails purchaseDetails) async {
    log('Starting receipt validation');
    const String sandboxUrl = 'https://sandbox.itunes.apple.com/verifyReceipt';
    const String productionUrl = 'https://buy.itunes.apple.com/verifyReceipt';
    const String sharedSecret = '79b1b20f3757407f91e8c54e196d5083';

    String? receipt;

    if (Platform.isIOS) {
      final addition = InAppPurchaseStoreKitPlatformAddition();
      final purchaseVerification = await addition.refreshPurchaseVerificationData();
      receipt = purchaseVerification?.localVerificationData;

      if (receipt == null || receipt.isEmpty) {
        log("❌ Could not retrieve app store receipt");
        return false;
      }
    } else {
      // On Android, use purchaseDetails.verificationData.serverVerificationData
      receipt = purchaseDetails.verificationData.localVerificationData;
    }


    final Map<String, dynamic> receiptBody = {
      'receipt-data': receipt,
      'exclude-old-transactions': true,
      'password': sharedSecret
    };

    try {
      dio_instance.Response response = await DioClient.instance.post(
        productionUrl,
        data: jsonEncode(receiptBody),
        options: dio_instance.Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.data['status'] == 21007) {
        log('Switching to sandbox environment for receipt validation');
        response = await DioClient.instance.post(
          sandboxUrl,
          data: jsonEncode(receiptBody),
          options: dio_instance.Options(headers: {'Content-Type': 'application/json'}),
        );
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = response.data;

        log(response.data.toString());
        if (responseBody['status'] == 0) {
          final List<dynamic>? receipts = responseBody['latest_receipt_info'];

          if (receipts == null || receipts.isEmpty) {
            log('❌ No receipt info available');
            return false;
          }


          // ✅ Check if the purchase is lifetime or a subscription
          print(purchaseDetails.productID);
          if (purchaseDetails.productID == 'aivideogenerator.lifetime.devsrank.com') {
            bool hasLifetimePurchase = receipts.any(
                  (receipt) => receipt['product_id'] == 'aivideogenerator.lifetime.devsrank.com',
            );

            if (hasLifetimePurchase) {
              log('✅ Lifetime purchase is still valid');
              return true;
            } else {
              log('❌ Lifetime purchase was refunded or removed');
              return false;
            }
          }

          // ✅ Subscription Validation (if it's not a lifetime purchase)
          final Map<String, dynamic> latestReceipt = receipts.last;
          final String expirationDateStr = latestReceipt['in_app_ownership_type'];

          if(expirationDateStr == "PURCHASED") {
            "purchased status success".printResponse(title: "validate purchase");
            return true;
          } else {
            "purchased status $expirationDateStr".printResponse(title: "validate purchase");
            return false;
          }

        } else {
          log('❌ Invalid status returned from Apple: ${responseBody['status']}');
          return false;
        }
      } else {
        log('❌ Request to Apple failed with status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('❌ Error validating receipt: $e');
      return false;
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}

class ExamplePaymentQueueDelegate extends SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction,
      SKStorefrontWrapper storefront,
      ) => true;

  @override
  bool shouldShowPriceConsent() => false;

  @override
  void transactionsUpdated(List<SKPaymentTransactionWrapper> transactions) {
    for (var t in transactions) {
      if (t.transactionState == SKPaymentTransactionStateWrapper.failed) {
        log("Purchase failed");
      }
    }
  }
}

