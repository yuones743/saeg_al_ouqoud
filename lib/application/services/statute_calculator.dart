class StatuteOfLimitations {
  static const Map<String, Map<String, dynamic>> rules = {
    'real_estate_dispute': {'years': 15, 'description': 'دعوى استحقاق عقار', 'note': 'تسقط بمضي 15 سنة'},
    'contract_breach': {'years': 10, 'description': 'دعوى إخلال بالعقد', 'note': 'تسقط بمضي 10 سنوات'},
    'rent_claim': {'years': 3, 'description': 'دعوى مطالبة بالأجور', 'note': 'تسقط بمضي 3 سنوات'},
    'inheritance_claim': {'years': 15, 'description': 'دعوى المطالبة بالإرث', 'note': 'تسقط بمضي 15 سنة'},
    'commercial_paper': {'years': 5, 'description': 'دعوى الأوراق التجارية', 'note': 'تسقط بمضي 5 سنوات'},
  };

  static int yearsFor(String key) => (rules[key]?['years'] as int?) ?? 0;
  static String descriptionFor(String key) => (rules[key]?['description'] as String?) ?? '';
  static String noteFor(String key) => (rules[key]?['note'] as String?) ?? '';

  static DateTime calculateDueDate(String key, DateTime startDate) {
    final years = yearsFor(key);
    if (years == 0) return startDate;
    return DateTime(startDate.year + years, startDate.month, startDate.day);
  }
}