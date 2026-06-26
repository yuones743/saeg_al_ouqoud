class DateHelpers {
  static const List<String> arabicMonths = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
  ];

  static const List<String> arabicDays = [
    'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'
  ];

  static String formatHijri(DateTime date) {
    return '${date.day} ${arabicMonths[date.month - 1]} ${date.year}';
  }

  static String formatGregorianAr(DateTime date) {
    final days = ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    return '${days[date.weekday - 1]} ${date.day}/${date.month}/${date.year}';
  }

  static bool isValidDate(String input) {
    final parts = input.split('/');
    if (parts.length != 3) return false;
    final d = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final y = int.tryParse(parts[2]);
    if (d == null || m == null || y == null) return false;
    return d >= 1 && d <= 31 && m >= 1 && m <= 12 && y >= 1900 && y <= 2200;
  }
}