import 'package:intl/intl.dart';

class ArabicTextHelpers {
  static const List<String> _arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  static String toArabicDigits(Object? value) {
    if (value == null) return '';
    final s = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final c = s[i];
      if (c.codeUnitAt(0) >= 0x30 && c.codeUnitAt(0) <= 0x39) {
        buffer.write(_arabicDigits[int.parse(c)]);
      } else {
        buffer.write(c);
      }
    }
    return buffer.toString();
  }

  static String formatDate(String input) {
    if (input.isEmpty) return '';
    try {
      final parts = input.split('/');
      if (parts.length == 3) {
        return '${toArabicDigits(int.tryParse(parts[0]) ?? parts[0])}/${toArabicDigits(int.tryParse(parts[1]) ?? parts[1])}/${toArabicDigits(int.tryParse(parts[2]) ?? parts[2])}';
      }
      return input;
    } catch (_) { return input; }
  }

  static String formatCurrency(double amount, {String currency = 'ل.س'}) {
    final fmt = NumberFormat.decimalPattern('en_US');
    final whole = fmt.format(amount.truncate());
    return '$whole $currency';
  }

  static String numberInWords(int n) {
    if (n == 0) return 'صفر';
    const ones = ['', 'واحد', 'اثنان', 'ثلاثة', 'أربعة', 'خمسة', 'ستة', 'سبعة', 'ثمانية', 'تسعة', 'عشرة',
      'أحد عشر', 'اثنا عشر', 'ثلاثة عشر', 'أربعة عشر', 'خمسة عشر', 'ستة عشر', 'سبعة عشر', 'ثمانية عشر', 'تسعة عشر'];
    const tens = ['', '', 'عشرون', 'ثلاثون', 'أربعون', 'خمسون', 'ستون', 'سبعون', 'ثمانون', 'تسعون'];
    if (n < 20) return ones[n];
    if (n < 100) {
      final t = n ~/ 10;
      final o = n % 10;
      if (o == 0) return tens[t];
      return '${ones[o]} و${tens[t]}';
    }
    if (n < 1000) {
      final h = n ~/ 100;
      final r = n % 100;
      final head = h == 1 ? 'مائة' : '${ones[h]}مائة';
      if (r == 0) return head;
      return '$head و${numberInWords(r)}';
    }
    if (n < 1000000) {
      final k = n ~/ 1000;
      final r = n % 1000;
      final head = k == 1 ? 'ألف' : '${numberInWords(k)} ألف';
      if (r == 0) return head;
      return '$head و${numberInWords(r)}';
    }
    return n.toString();
  }

  static String simplifyFraction(int numerator, int denominator) {
    if (numerator == 0) return '٠';
    if (denominator == 0) return '٠';
    var a = numerator.abs();
    var b = denominator.abs();
    while (b != 0) { final t = b; b = a % b; a = t; }
    final gcd = a == 0 ? 1 : a;
    final n = numerator ~/ gcd;
    final d = denominator ~/ gcd;
    if (d == 1) return toArabicDigits(n);
    return '${toArabicDigits(n)}/${toArabicDigits(d)}';
  }
}