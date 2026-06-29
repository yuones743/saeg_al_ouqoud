// ───────────────────────────────────────────────────────────────────────────────
// 📁 الملف: lib/core/constants/syrian_property_law.dart
// 📦 الوصف: ثوابت قانون العقارات السوري
// ───────────────────────────────────────────────────────────────────────────────

/// ثوابت قانون العقارات السوري
class SyrianPropertyLaw {
  /// إجمالي عدد الأسهم في العقار (24 قيراط × 100 سهم)
  static const int totalShares = 2400;

  /// عدد القراريط الكلي
  static const int totalQirat = 24;

  /// عدد الأسهم في القيراط الواحد
  static const int sharesPerQirat = 100;

  /// يحسب الحصة المتساوية لكل طرف
  static double calculateEqualShare(int partyCount) {
    if (partyCount <= 0) return 0;
    return totalShares / partyCount;
  }
}
