import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPrefKeys {
  static const kOnboardDisplayKey = "onboard_display";
  static const kFreeTrialKey = "free_trial";
  static const kDailySubscriptionUsageDateKey = "daily_subscription_usage_date";
  static const kDailySubscriptionUsageCountKey = "daily_subscription_usage_count";
}

class SharedPrefService extends SharedPrefKeys {

  static Future<SharedPreferences> get _prefInstance async => await SharedPreferences.getInstance();

  static Future<({bool isUsageLeft})> checkDailySubscriptionUsageLimit() async {
    final pref = await _prefInstance;
    final dateStr = pref.getString(SharedPrefKeys.kDailySubscriptionUsageDateKey);
    final count = pref.getInt(SharedPrefKeys.kDailySubscriptionUsageCountKey) ?? 0;

    final now = DateTime.now();
    DateTime? savedDate;

    if (dateStr != null) {
      savedDate = DateTime.tryParse(dateStr);
    }

    // Reset count if date is different from today
    if (savedDate == null || !_isSameDay(savedDate, now)) {
      await pref.setString(SharedPrefKeys.kDailySubscriptionUsageDateKey, now.toIso8601String());
      await pref.setInt(SharedPrefKeys.kDailySubscriptionUsageCountKey, 0);
      return (isUsageLeft: true);
    }

    // Check if user still has usage left
    return (isUsageLeft: count < 10);
  }

  static bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  static Future<void> updateDailySubscriptionUsageLimit() async {
    final pref = await _prefInstance;
    final count = pref.getInt(SharedPrefKeys.kDailySubscriptionUsageCountKey) ?? 0;
    await pref.setInt(SharedPrefKeys.kDailySubscriptionUsageCountKey, count + 1);
  }

  static Future<({bool display})> getOnboardDisplay() async {
    final pref = await _prefInstance;
    return (display: pref.getBool(SharedPrefKeys.kOnboardDisplayKey) ?? true);
  }

  static Future<void> setOnboardDisplay({required bool display}) async {
    final pref = await _prefInstance;
    await pref.setBool(SharedPrefKeys.kOnboardDisplayKey, display);
  }

  static Future<({bool isFreeTrialLeft})> checkFreeTrial() async {
    final pref = await _prefInstance;
    final freeTrial = pref.getInt(SharedPrefKeys.kFreeTrialKey);
    if(freeTrial != null) {
      return (isFreeTrialLeft: freeTrial < 1);
    } else {
      await pref.setInt(SharedPrefKeys.kFreeTrialKey, 0);
      return (isFreeTrialLeft: true);
    }
  }

  static Future<void> updateFreeTrialLimit() async {
    final pref = await _prefInstance;
    final freeTrial = pref.getInt(SharedPrefKeys.kFreeTrialKey);
    if(freeTrial != null) {
      await pref.setInt(SharedPrefKeys.kFreeTrialKey, freeTrial+1);
    } else {
      await pref.setInt(SharedPrefKeys.kFreeTrialKey, 0);
    }
  }

  static Future<void> clearPref() async {
    final pref = await _prefInstance;
    await pref.clear();
  }
}