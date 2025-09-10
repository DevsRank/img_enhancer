
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as dio_instance;
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_enhancer_app/config/shared_preference/shared_pref_service.dart';
import 'package:image_enhancer_app/main.dart';
import 'package:image_enhancer_app/utils/enum/in_app_purchase_subscription_status.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/navigator_extension.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:intl/intl.dart';

class InAppPurchaseSubscriptionState extends Equatable {

  bool isLoading;
  InAppPurchaseSubscriptionStatus subscriptionStatus;

  InAppPurchaseSubscriptionState({
    this.isLoading = false,
    this.subscriptionStatus = InAppPurchaseSubscriptionStatus.NONE
  });

  InAppPurchaseSubscriptionState copyWith({bool? isLoading, InAppPurchaseSubscriptionStatus? subscriptionStatus}) {
    return InAppPurchaseSubscriptionState(
        isLoading: isLoading ?? this.isLoading,
        subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus
    );
  }

  @override
  List<Object> get props => [isLoading, subscriptionStatus];
}

class InAppPurchaseSubscriptionBloc extends Cubit<InAppPurchaseSubscriptionState> {
  Timer? _timer;
  InAppPurchaseSubscriptionBloc() : super(InAppPurchaseSubscriptionState());

  void initFunction() async {

    // startSubscriptionTimer(DateTime.parse("2025-07-08 15:29:12.000"));

    emit(state.copyWith(isLoading: true));

    final futureList = await Future.wait([
      _validatePurchase(),
      SharedPrefService.checkDailySubscriptionUsageLimit()
      // SharedPrefService.checkFreeTrial(),
    ]);

    if((futureList[0] as bool) && (futureList[1] as ({bool isUsageLeft})).isUsageLeft) {
      "premium subscription activate".printResponse(title: "subscription bloc");
      emit(state.copyWith(isLoading: false, subscriptionStatus: InAppPurchaseSubscriptionStatus.PREMIUM_SUBSCRIPTION));
    } else if((futureList[0] as bool) && !(futureList[1] as ({bool isUsageLeft})).isUsageLeft) {
      "subscription limit exceeded".printResponse(title: "subscription bloc");
      emit(state.copyWith(isLoading: false, subscriptionStatus: InAppPurchaseSubscriptionStatus.DIALY_SUBSCRIPTION_USAGE_LIMIT_EXCEEDED));
    }
    // else if((futureList[2] as ({bool isFreeTrialLeft})).isFreeTrialLeft) {
    //   "free trial activate".printResponse(title: "subscription bloc");
    //   emit(state.copyWith(loading: false, subscriptionStatus: InAppPurchaseSubscriptionStatus.FREETRIAL));
    // }
    else {
      "no state activate".printResponse(title: "subscription bloc");
      emit(state.copyWith(isLoading: false, subscriptionStatus: InAppPurchaseSubscriptionStatus.NONE));
    }

  }

  DateTime _parseAppleDate(String dateStr) {
    return DateFormat("yyyy-MM-dd HH:mm:ss z").parse(dateStr);
  }

  DateTime _truncateToSeconds(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);
  }

  Future<bool> _validatePurchase() async {

    String? receipt;

    if (Platform.isIOS) {
      final addition = InAppPurchaseStoreKitPlatformAddition();
      final purchaseVerification = await addition.refreshPurchaseVerificationData();
      receipt = purchaseVerification?.localVerificationData ?? "";

      if (receipt.isEmpty) {
        log("❌ Could not retrieve app store receipt");
      }
    } else {
      // On Android, use purchaseDetails.verificationData.serverVerificationData
      receipt = "";
    }

    if(receipt.isNotEmpty) {

      log('Starting receipt validation');
      const String sandboxUrl = 'https://sandbox.itunes.apple.com/verifyReceipt';
      const String productionUrl = 'https://buy.itunes.apple.com/verifyReceipt';
      const String sharedSecret = 'ddb13bb48f274aee9d6f879eea8703a6';

      final Map<String, dynamic> receiptBody = {
        'receipt-data': receipt,
        'exclude-old-transactions': true,
        'password': sharedSecret,
      };

      try {
        dio_instance.Response response = await Dio().post(
          productionUrl,
          data: jsonEncode(receiptBody),
          options: dio_instance.Options(headers: {'Content-Type': 'application/json'}),
        );

        if (response.data['status'] == 21007) {
          log('Switching to sandbox environment for receipt validation');
          response = await Dio().post(
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


            // if (pref.productId == 'chatbot.lifetime.devsrank.com') {
            //   bool hasLifetimePurchase = receipts.any(
            //         (receipt) => receipt['product_id'] == 'chatbot.lifetime.devsrank.com',
            //   );
            //
            //   if (hasLifetimePurchase) {
            //     log('✅ Lifetime purchase is still valid');
            //     return true;
            //   } else {
            //     log('❌ Lifetime purchase was refunded or removed');
            //     return false;
            //   }
            // }

            // ✅ Subscription Validation (if it's not a lifetime purchase)
            final Map<String, dynamic> latestReceipt = receipts.last;
            final String expirationDateStr = latestReceipt['expires_date'];
            final DateTime expirationDate = _truncateToSeconds(_parseAppleDate(expirationDateStr));
            final bool isExpired = expirationDate.isBefore(_truncateToSeconds(DateTime.now().toUtc()));

            log('Is Expired Value is $isExpired');
            log("Date Time Now : ${DateTime.now().toUtc()}");
            log("Expiration Date Time : $expirationDate");

            if (!isExpired) {
              log('Subscription is valid');
              // to cancel subscription on tme
              startSubscriptionTimer(expirationDate);
              return true;
            } else {
              log('Subscription has expired');
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

    } else {
      return false;
    }
  }

  Future<void> updateFreeTrialLimit() async {
    // emit(state.copyWith(loading: true));
    await SharedPrefService.updateFreeTrialLimit();
    final pref = await SharedPrefService.checkFreeTrial();
    "free trial ${pref.isFreeTrialLeft ? "activate" : "deactivate"}".printResponse(title: "subscription bloc");
    emit(state.copyWith(isLoading: false, subscriptionStatus: pref.isFreeTrialLeft ? InAppPurchaseSubscriptionStatus.FREETRIAL : InAppPurchaseSubscriptionStatus.NONE));
  }

  Future<void> handlePremiumSubscription() async {
    emit(state.copyWith(isLoading: true));
    if(materialAppKey.currentContext != null) {
      emit(state.copyWith(isLoading: false, subscriptionStatus: InAppPurchaseSubscriptionStatus.PREMIUM_SUBSCRIPTION));
      Future.delayed(200.millisecond, () {
        materialAppKey.currentContext?.pop();
      });
    }
  }

  void startSubscriptionTimer(DateTime expirationDate) {
    return;
    "startSubscriptionTimer called".printResponse(title: "subscription bloc");

    _timer?.cancel();

    final now = _truncateToSeconds(DateTime.now().toUtc());
    final exp = _truncateToSeconds(expirationDate);
    final timeRemaining = exp.difference(now);

    "Now: $now | Expiration: $exp | TimeLeft: ${timeRemaining}"
        .printResponse(title: "subscription bloc");

    if (timeRemaining.isNegative) {
      "time date is negative".printResponse(title: "subscription bloc");
      return;
    }

    "subscription timer has been start".printResponse(title: "subscription bloc");

    _timer = Timer.periodic(1.second, (timer) {
      final now = _truncateToSeconds(DateTime.now().toUtc());
      final newRemaining = exp.difference(now);

      "Timer tick: $newRemaining".printResponse(title: "subscription bloc");

      if (newRemaining.isNegative) {
        timer.cancel();
        "subscription has been expired".printResponse(title: "subscription bloc");
        emit(state.copyWith(subscriptionStatus: InAppPurchaseSubscriptionStatus.NONE));
      }
    });
  }

  Future<void> updateDailySubscriptionUsageLimit() async {
    await SharedPrefService.updateDailySubscriptionUsageLimit();
    final pref = await SharedPrefService.checkDailySubscriptionUsageLimit();
    if(!pref.isUsageLeft) {
      emit(state.copyWith(subscriptionStatus: InAppPurchaseSubscriptionStatus.DIALY_SUBSCRIPTION_USAGE_LIMIT_EXCEEDED));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

}