class FormValidators {
  static String? requiredText(String? v) {
    if (v == null || v.trim().isEmpty) return 'هذا الحقل مطلوب';
    return null;
  }

  static String? positiveNumber(String? v) {
    if (v == null || v.trim().isEmpty) return 'الرجاء إدخال رقم';
    final n = double.tryParse(v);
    if (n == null) return 'الرقم غير صحيح';
    if (n < 0) return 'الرقم يجب أن يكون موجباً';
    return null;
  }

  static String? date(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final parts = v.split('/');
    if (parts.length != 3) return 'الصيغة: يوم/شهر/سنة';
    final d = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final y = int.tryParse(parts[2]);
    if (d == null || m == null || y == null) return 'الرجاء إدخال أرقام';
    if (d < 1 || d > 31) return 'اليوم يجب أن يكون 1-31';
    if (m < 1 || m > 12) return 'الشهر يجب أن يكون 1-12';
    if (y < 1900 || y > 2100) return 'السنة غير معقولة';
    return null;
  }
}