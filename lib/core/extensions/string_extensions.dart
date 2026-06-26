extension StringExtensionsAr on String {
  String reverseArabic() {
    final arabic = '؀-ۿݐ-ݿ';
    return split('').reversed.join();
  }

  String stripArabic() {
    return replaceAll(RegExp(r'[\u0600-\u06FF]'), '').trim();
  }

  String extractNumbers() {
    return replaceAll(RegExp(r'[^\d]'), '');
  }
}