import '../../domain/models/legal_contract.dart';

class ContractGenerator {
  static String generate(LegalContractData data) {
    final buffer = StringBuffer();

    buffer.writeln('بسم الله الرحمن الرحيم');
    buffer.writeln('');
    buffer.writeln(_getTitle(data.type));
    buffer.writeln('تاريخ التحرير: ${_formatDate(data.createdAt)}');
    buffer.writeln('=' * 50);
    buffer.writeln('');

    buffer.writeln(_getPartiesSection(data));
    buffer.writeln('');

    buffer.writeln(_getPreamble(data));
    buffer.writeln('');

    buffer.writeln(_getSubjectSection(data));
    buffer.writeln('');

    buffer.writeln(_getPriceSection(data));
    buffer.writeln('');

    buffer.writeln(_getDeliverySection(data));
    buffer.writeln('');

    buffer.writeln(_getPenaltySection(data));
    buffer.writeln('');

    if (data.customClauses.isNotEmpty) {
      buffer.writeln(_getCustomClauses(data.customClauses));
      buffer.writeln('');
    }

    buffer.writeln(_getSignaturesSection(data));

    return buffer.toString();
  }

  static String _getTitle(ContractType type) {
    switch (type) {
      case ContractType.sale: return 'عقد بيع عقاري قطعي ونهائي';
      case ContractType.rent: return 'عقد إيجار عقاري شامل';
      case ContractType.gift: return 'عقد هبة عقارية';
      case ContractType.partnership: return 'عقد مشاركة ومقايضة';
      case ContractType.vehicleSale: return 'عقد بيع مركبة قطعي';
      case ContractType.vehicleRent: return 'عقد إيجار مركبة';
      case ContractType.agency: return 'وكالة خاصة غير قابلة للعزل';
      default: return 'عقد قانوني';
    }
  }

  static String _getPartiesSection(LegalContractData data) {
    final buffer = StringBuffer();

    if (data.sellers.isNotEmpty) {
      buffer.writeln('الفريق الأول (البائعون):');
      for (var i = 0; i < data.sellers.length; i++) {
        final p = data.sellers[i];
        buffer.writeln('${i + 1}. السيد/ة: ${p.fullName}');
        buffer.writeln('   الرقم الوطني: ${p.nationalId}');
        buffer.writeln('   حصته في العقار: ${p.share} سهماً');
        buffer.writeln('   الصفة: ${_getCapacityLabel(p.capacity)}');
        if (p.poaNumber != null) {
          buffer.writeln('   بموجب وكالة رقم: ${p.poaNumber} تاريخ ${p.poaDate}');
        }
        if (p.isMinor) buffer.writeln('   (قاصر - بموجب وصاية شرعية)');
        buffer.writeln('   الهاتف: ${p.phone}');
        buffer.writeln('   العنوان: ${p.address}');
        buffer.writeln('');
      }
    }

    if (data.buyers.isNotEmpty) {
      buffer.writeln('الفريق الثاني (المشترون):');
      for (var i = 0; i < data.buyers.length; i++) {
        final p = data.buyers[i];
        buffer.writeln('${i + 1}. السيد/ة: ${p.fullName}');
        buffer.writeln('   الرقم الوطني: ${p.nationalId}');
        buffer.writeln('   حصته المشتراة: ${p.share} سهماً');
        buffer.writeln('   الهاتف: ${p.phone}');
        buffer.writeln('   العنوان: ${p.address}');
        buffer.writeln('');
      }
    }

    return buffer.toString();
  }

  static String _getSubjectSection(LegalContractData data) {
    final buffer = StringBuffer();
    buffer.writeln('المادة الأولى: موضوع العقد');
    buffer.writeln('باع الفريق الأول للفريق الثاني العقار رقم ${data.propertyNumber}');
    buffer.writeln('في المنطقة العقارية: ${data.propertyZone}');
    buffer.writeln('العنوان: ${data.propertyAddress}');
    buffer.writeln('المساحة الإجمالية: ${data.propertyArea} م²');
    buffer.writeln('الحدود: ${data.boundaries}');
    buffer.writeln('');

    buffer.writeln('توزيع حصص البائعين:');
    for (var i = 0; i < data.sellers.length; i++) {
      final p = data.sellers[i];
      buffer.writeln('- البائع ${i + 1} (${p.fullName}): ${p.share} سهماً');
    }

    buffer.writeln('');
    buffer.writeln('توزيع حصص المشترين:');
    for (var i = 0; i < data.buyers.length; i++) {
      final p = data.buyers[i];
      buffer.writeln('- المشتري ${i + 1} (${p.fullName}): ${p.share} سهماً');
    }

    return buffer.toString();
  }

  static String _getPriceSection(LegalContractData data) {
    final buffer = StringBuffer();
    buffer.writeln('المادة الثانية: الثمن');
    buffer.writeln('تم هذا البيع لقاء ثمن إجمالي قدره ${data.totalPrice} ل.س');
    buffer.writeln('طريقة الدفع: ${data.paymentMethod}');
    return buffer.toString();
  }

  static String _getDeliverySection(LegalContractData data) {
    return '''
المادة الثالثة: التسليم والفراغ
يلتزم البائعون بتسليم العقار خالياً من الشواغل، والحضور أمام المصالح العقارية لنقل الملكية للمشترين فوراً.
''';
  }

  static String _getPenaltySection(LegalContractData data) {
    return '''
المادة الرابعة: الشرط الجزائي
هذا البيع قطعي ونهائي. في حال نكول أو تخلف أي من الأطراف عن تنفيذ التزاماته، يلتزم الطرف الناكل بدفع تعويض قدره ${data.penaltyAmount} ل.س للطرف الآخر، كشرط جزائي فوري غير قابل للفسخ أو التعديل.
''';
  }

  static String _getSignaturesSection(LegalContractData data) {
    final buffer = StringBuffer();
    buffer.writeln('المادة الخامسة: التواقيع');
    buffer.writeln('');

    buffer.writeln('البائعون:');
    for (var i = 0; i < data.sellers.length; i++) {
      buffer.writeln('${i + 1}. ................................ (بصمة)');
    }
    buffer.writeln('');

    buffer.writeln('المشترون:');
    for (var i = 0; i < data.buyers.length; i++) {
      buffer.writeln('${i + 1}. ................................ (بصمة)');
    }
    buffer.writeln('');

    buffer.writeln('الشهود:');
    buffer.writeln('1. ................................');
    buffer.writeln('2. ................................');
    buffer.writeln('');
    buffer.writeln('حرر هذا العقد من نسختين أصليتين، بيد كل طرف نسخة للعمل بموجبها.');

    return buffer.toString();
  }

  static String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';

  static String _getCapacityLabel(LegalCapacity c) {
    switch (c) {
      case LegalCapacity.individual:
        return 'أصيل';
      case LegalCapacity.guardian:
        return 'وصي شرعي';
      case LegalCapacity.agent:
        return 'وكيل';
      case LegalCapacity.legalEntity:
        return 'شخص اعتباري';
      default:
        return 'أصيل';
    }
  }

  static String _getPreamble(LegalContractData data) {
    return '''
بأهليتهما الكاملة المعتبرة شرعاً وقانوناً، وخلوهما من كافة عوارض الأهلية وموانع التصرف، اتفق الأطراف على البنود التالية:
''';
  }

  static String _getCustomClauses(List<String> clauses) {
    final buffer = StringBuffer();
    buffer.writeln('بنود إضافية:');
    for (var i = 0; i < clauses.length; i++) {
      buffer.writeln('${i + 1}. ${clauses[i]}');
    }
    return buffer.toString();
  }
}
