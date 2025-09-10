
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_enhancer_app/service/in_app_purchase/in_app_purchase_subscription_bloc.dart';
import 'package:image_enhancer_app/utils/enum/in_app_purchase_subscription_status.dart';

class PremiumWidgetVisibilityWidget extends StatelessWidget {
  final Widget child;
  const PremiumWidgetVisibilityWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InAppPurchaseSubscriptionBloc, InAppPurchaseSubscriptionState>(
        builder: (context, inAppPurchaseSubscriptionState) {
          return inAppPurchaseSubscriptionState.subscriptionStatus != InAppPurchaseSubscriptionStatus.PREMIUM_SUBSCRIPTION && inAppPurchaseSubscriptionState.subscriptionStatus != InAppPurchaseSubscriptionStatus.DIALY_SUBSCRIPTION_USAGE_LIMIT_EXCEEDED
              ? child : SizedBox.shrink();
          });
  }
}
