import '../../domain/models/contract.dart';

class LegalScenario {
  final String code;
  final String titleAr;
  final String category;
  final String descriptionAr;
  final List<String> triggers;
  final String referenceArticle;
  const LegalScenario({
    required this.code,
    required this.titleAr,
    required this.category,
    required this.descriptionAr,
    required this.triggers,
    required this.referenceArticle,
  });
}

class ScenarioRegistry {
  static final List<LegalScenario> all = [
    LegalScenario(code: 'S001', titleAr: 'بيع شقة سكنية', category: 'طبيعة المبيع', descriptionAr: 'عقد بيع عقار سكني (شقة)', triggers: ['property_type=apartment'], referenceArticle: 'المادة 558 مدني'),
    LegalScenario(code: 'S002', titleAr: 'بيع محل تجاري', category: 'طبيعة المبيع', descriptionAr: 'بيع محل تجاري بعقد منفصل عن العقار', triggers: ['property_type=shop'], referenceArticle: 'قانون التجارة 33/1942'),
    LegalScenario(code: 'S003', titleAr: 'بيع أرض ملك', category: 'طبيعة المبيع', descriptionAr: 'بيع أرض مملوكة للقطاع الخاص', triggers: ['property_type=ownedLand'], referenceArticle: 'المادة 558 مدني'),
    LegalScenario(code: 'S004', titleAr: 'بيع أرض أميرية', category: 'طبيعة المبيع', descriptionAr: 'بيع أرض أميرية يخضع لتساوي الذكور والإناث في الإرث', triggers: ['property_type=amiriaLand'], referenceArticle: 'قانون الأراضي الأميرية'),
    LegalScenario(code: 'S005', titleAr: 'بيع سيارة خصوصي', category: 'طبيعة المبيع', descriptionAr: 'بيع سيارة بسيط بعقد بيع عادي', triggers: ['property_type=privateVehicle'], referenceArticle: 'المادة 558 مدني'),
    LegalScenario(code: 'S006', titleAr: 'بيع سيارة أجرة', category: 'طبيعة المبيع', descriptionAr: 'بيع سيارة عمومي/تاكسي مع الترخيص', triggers: ['property_type=taxiVehicle'], referenceArticle: 'قانون النقل'),
    LegalScenario(code: 'S007', titleAr: 'بيع شاحنة', category: 'طبيعة المبيع', descriptionAr: 'بيع شاحنة نقل', triggers: ['property_type=truck'], referenceArticle: 'قانون التجارة'),
    LegalScenario(code: 'S008', titleAr: 'بيع آلية ثقيلة/تركس', category: 'طبيعة المبيع', descriptionAr: 'بيع معدة ثقيلة', triggers: ['property_type=heavyMachinery'], referenceArticle: 'قانون التجارة'),
    LegalScenario(code: 'S009', titleAr: 'بيع جرار زراعي', category: 'طبيعة المبيع', descriptionAr: 'بيع جرار زراعي', triggers: ['property_type=agriculturalTractor'], referenceArticle: 'قانون التجارة'),
    LegalScenario(code: 'S010', titleAr: 'بيع حق انتفاع – سطح', category: 'حق الانتفاع', descriptionAr: 'بيع حق انتفاع بسطح عقار', triggers: ['type=usufructSale', 'subtype=rooftop'], referenceArticle: 'المادة 858 مدني'),
    LegalScenario(code: 'S011', titleAr: 'بيع حق انتفاع – قبو', category: 'حق الانتفاع', descriptionAr: 'بيع حق انتفاع بقبو', triggers: ['type=usufructSale', 'subtype=basement'], referenceArticle: 'المادة 858 مدني'),
    LegalScenario(code: 'S012', titleAr: 'بيع حق انتفاع – ملحق', category: 'حق الانتفاع', descriptionAr: 'بيع حق انتفاع بملحق', triggers: ['type=usufructSale', 'subtype=annex'], referenceArticle: 'المادة 858 مدني'),
    LegalScenario(code: 'S013', titleAr: 'بيع حصة شائعة', category: 'حصص شائعة', descriptionAr: 'بيع جزء من عقار مشترك', triggers: ['property_is_common_share=true'], referenceArticle: 'المادة 1026 مدني'),
    LegalScenario(code: 'S014', titleAr: 'بيع فيلا', category: 'طبيعة المبيع', descriptionAr: 'بيع فيلا سكنية', triggers: ['property_type=villa'], referenceArticle: 'المادة 558 مدني'),
    LegalScenario(code: 'S015', titleAr: 'بيع بيت عربي', category: 'طبيعة المبيع', descriptionAr: 'بيع بيت عربي قديم', triggers: ['property_type=arabicHouse'], referenceArticle: 'المادة 558 مدني'),
    LegalScenario(code: 'S016', titleAr: 'بيع مزرعة', category: 'طبيعة المبيع', descriptionAr: 'بيع مزرعة كاملة مع أبنتها', triggers: ['property_type=farm'], referenceArticle: 'المادة 558 مدني'),
    LegalScenario(code: 'S017', titleAr: 'بيع أرض زراعية', category: 'طبيعة المبيع', descriptionAr: 'بيع أرض زراعية', triggers: ['property_type=agriculturalLand'], referenceArticle: 'المادة 558 مدني'),
    LegalScenario(code: 'S018', titleAr: 'إرث متعدد الورثة', category: 'الإرث', descriptionAr: 'توزيع إرث على عدة ورثة', triggers: ['heirs.length>1'], referenceArticle: 'قانون الأحوال 59/1953'),
    LegalScenario(code: 'S019', titleAr: 'إرث وارث واحد', category: 'الإرث', descriptionAr: 'تركة تذهب لوارث واحد', triggers: ['heirs.length=1'], referenceArticle: 'قانون الأحوال 59/1953'),
    LegalScenario(code: 'S020', titleAr: 'إرث قاصر', category: 'الإرث', descriptionAr: 'وجود وريث قاصر', triggers: ['heir.isMinor=true'], referenceArticle: 'قانون حماية القاصرين'),
    LegalScenario(code: 'S021', titleAr: 'إرث مغترب', category: 'الإرث', descriptionAr: 'وارث مغترب يحتاج وكيل', triggers: ['heir.isExpatriate=true'], referenceArticle: 'المادة 132 أحوال'),
    LegalScenario(code: 'S022', titleAr: 'إرث مفقود', category: 'الإرث', descriptionAr: 'وارث مفقود يُودع نصيبه', triggers: ['heir.person.isMissing=true'], referenceArticle: 'المادة 154 أحوال'),
    LegalScenario(code: 'S023', titleAr: 'إرث كلالة', category: 'الإرث', descriptionAr: 'حالة كلالة (لا أولاد ولا والدين)', triggers: ['is_kalala=true'], referenceArticle: 'المادة 23 أحوال'),
    LegalScenario(code: 'S024', titleAr: 'إرث بحجب', category: 'الإرث', descriptionAr: 'حجب بعض الورثة بوجود الفرع', triggers: ['hasDescendants=true'], referenceArticle: 'المادة 17 أحوال'),
    LegalScenario(code: 'S025', titleAr: 'وصية واجبة', category: 'الإرث', descriptionAr: 'الوصية الواجبة لأولاد الابن المتوفى', triggers: ['will_exceeds_third=true'], referenceArticle: 'المادة 182 أحوال'),
    LegalScenario(code: 'S026', titleAr: 'حمل مستكن', category: 'الإرث', descriptionAr: 'تأجيل القسمة لوجود حمل', triggers: ['has_pregnant_heir=true'], referenceArticle: 'المادة 306 مدني'),
    LegalScenario(code: 'S027', titleAr: 'حرمان من الإرث – قتل', category: 'الإرث', descriptionAr: 'حرمان القاتل من الميراث', triggers: ['has_killer_heir=true'], referenceArticle: 'المادة 28 أحوال'),
    LegalScenario(code: 'S028', titleAr: 'حرمان من الإرث – ردة', category: 'الإرث', descriptionAr: 'حرمان المرتد من الميراث', triggers: ['has_apostate_heir=true'], referenceArticle: 'المادة 29 أحوال'),
    LegalScenario(code: 'S029', titleAr: 'طلاق في مرض الموت', category: 'الإرث', descriptionAr: 'طلاق الزوجة في مرض الموت يحفظ حقها', triggers: ['divorce_during_illness=true'], referenceArticle: 'المادة 86 أحوال'),
    LegalScenario(code: 'S030', titleAr: 'تعدد الزوجات', category: 'الإرث', descriptionAr: 'تعدد الزوجات يؤثر على الأنصبة', triggers: ['marriage_count>1'], referenceArticle: 'المادة 107 أحوال'),
    LegalScenario(code: 'S031', titleAr: 'وارث خنثى', category: 'الإرث', descriptionAr: 'حجز النصيب حتى التحديد الطبي', triggers: ['has_intersex_heir=true'], referenceArticle: 'المادة 50 أحوال'),
    LegalScenario(code: 'S032', titleAr: 'وارث أسير', category: 'الإرث', descriptionAr: 'الأسير يحتاج تمثيلاً قانونياً', triggers: ['has_prisoner_heir=true'], referenceArticle: 'المادة 132 أحوال'),
    LegalScenario(code: 'S033', titleAr: 'عقار محجوز', category: 'حالة العقار', descriptionAr: 'عقار عليه حجز قضائي', triggers: ['property_has_seizure=true'], referenceArticle: 'قانون التنفيذ'),
    LegalScenario(code: 'S034', titleAr: 'عقار مرهون', category: 'حالة العقار', descriptionAr: 'عقار عليه رهن', triggers: ['property_has_mortgage=true'], referenceArticle: 'المادة 1104 مدني'),
    LegalScenario(code: 'S035', titleAr: 'عقار عليه دعوى', category: 'حالة العقار', descriptionAr: 'عقار عليه دعوى نشطة', triggers: ['property_has_active_lawsuit=true'], referenceArticle: 'قانون أصول المحاكمات'),
    LegalScenario(code: 'S036', titleAr: 'عقار موقوف', category: 'حالة العقار', descriptionAr: 'عقار موقوف شرعاً', triggers: ['property_is_endowment=true'], referenceArticle: 'قانون الأوقاف 31/2018'),
    LegalScenario(code: 'S037', titleAr: 'عقار مخالف', category: 'حالة العقار', descriptionAr: 'عقار مخالف للتنظيم', triggers: ['property_is_violation=true'], referenceArticle: 'قانون البناء'),
    LegalScenario(code: 'S038', titleAr: 'حصة شائعة', category: 'حالة العقار', descriptionAr: 'بيع حصة من عقار مشترك', triggers: ['property_is_common_share=true'], referenceArticle: 'المادة 1026 مدني'),
    LegalScenario(code: 'S039', titleAr: 'عقار تحت الاستملاك', category: 'حالة العقار', descriptionAr: 'عقار تحت إجراءات الاستملاك', triggers: ['property_under_expropriation=true'], referenceArticle: 'قانون الاستملاك 20/1983'),
    LegalScenario(code: 'S040', titleAr: 'مهر قاصر', category: 'حالة العقار', descriptionAr: 'عقار مهر لقاصر', triggers: ['property_is_minors_dowry=true'], referenceArticle: 'المادة 80 أحوال'),
    LegalScenario(code: 'S041', titleAr: 'مشتري سوري', category: 'المشتري', descriptionAr: 'مشتري سوري بدون قيود', triggers: ['buyer_nationality=syrian'], referenceArticle: 'المادة 558 مدني'),
    LegalScenario(code: 'S042', titleAr: 'مشتري غير سوري بترخيص', category: 'المشتري', descriptionAr: 'مشتري أجنبي يحمل ترخيص استثمار', triggers: ['buyer_nationality=foreignLicensed', 'buyer_has_foreign_license=true'], referenceArticle: 'قانون الاستثمار 18/2021'),
    LegalScenario(code: 'S043', titleAr: 'مشتري مزدوج الجنسية', category: 'المشتري', descriptionAr: 'مشتري يحمل الجنسيتين', triggers: ['buyer_nationality=dualNational'], referenceArticle: 'قانون الجنسية'),
    LegalScenario(code: 'S044', titleAr: 'مشتري شخص اعتباري', category: 'المشتري', descriptionAr: 'شركة أو مؤسسة', triggers: ['buyer_nationality=legalEntity'], referenceArticle: 'قانون الشركات'),
    LegalScenario(code: 'S045', titleAr: 'بائع واحد', category: 'تعدد الأطراف', descriptionAr: 'بائع منفرد', triggers: ['sellers.length=1'], referenceArticle: 'المادة 558 مدني'),
    LegalScenario(code: 'S046', titleAr: 'بائعون متعددون', category: 'تعدد الأطراف', descriptionAr: 'عدة بائعين', triggers: ['sellers.length>1'], referenceArticle: 'المادة 558 مدني'),
    LegalScenario(code: 'S047', titleAr: 'مشترون متعددون', category: 'تعدد الأطراف', descriptionAr: 'عدة مشترين بحصص متساوية', triggers: ['buyers.length>1'], referenceArticle: 'المادة 558 مدني'),
    LegalScenario(code: 'S048', titleAr: 'مشترون بحصص غير متساوية', category: 'تعدد الأطراف', descriptionAr: 'حصة كل مشتري محددة', triggers: ['buyers_shares_uneven=true'], referenceArticle: 'المادة 558 مدني'),
    LegalScenario(code: 'S049', titleAr: 'دفع نقدي دفعة واحدة', category: 'الدفع', descriptionAr: 'ثمن مدفوع كاملاً نقداً', triggers: ['payment_method=cash', 'paidAmount=totalPrice'], referenceArticle: 'المادة 558 مدني'),
    LegalScenario(code: 'S050', titleAr: 'دفع على دفعتين', category: 'الدفع', descriptionAr: 'دفعة مقدمة + دفعة عند التسليم', triggers: ['installments.length=2'], referenceArticle: 'المادة 558 مدني'),
    LegalScenario(code: 'S051', titleAr: 'تقسيط على دفعات', category: 'الدفع', descriptionAr: 'تقسيط طويل الأجل', triggers: ['installments.length>2'], referenceArticle: 'المادة 558 مدني'),
    LegalScenario(code: 'S052', titleAr: 'دفع بالحوالة', category: 'الدفع', descriptionAr: 'حوالة مصرفية', triggers: ['payment_method=bankTransfer'], referenceArticle: 'قانون التجارة'),
    LegalScenario(code: 'S053', titleAr: 'دفع بشيك', category: 'الدفع', descriptionAr: 'شيك مصرفي أو بنكي', triggers: ['payment_method=check'], referenceArticle: 'قانون الأوراق التجارية'),
    LegalScenario(code: 'S054', titleAr: 'ثمن بالدولار', category: 'العملة', descriptionAr: 'عقد بعملة الدولار', triggers: ['currency=usd'], referenceArticle: 'قانون التجارة'),
    LegalScenario(code: 'S055', titleAr: 'ثمن باليورو', category: 'العملة', descriptionAr: 'عقد بعملة اليورو', triggers: ['currency=eur'], referenceArticle: 'قانون التجارة'),
    LegalScenario(code: 'S056', titleAr: 'ثمن بالذهب', category: 'العملة', descriptionAr: 'تسعير بالذهب عيار 21', triggers: ['currency=gold'], referenceArticle: 'قانون التجارة'),
    LegalScenario(code: 'S057', titleAr: 'عقد صلح', category: 'عقود خاصة', descriptionAr: 'عقد صلح بين طرفين', triggers: ['type=settlement'], referenceArticle: 'المادة 1047 مدني'),
    LegalScenario(code: 'S058', titleAr: 'عقد صلح مع وساطة', category: 'عقود خاصة', descriptionAr: 'صلح بوجود وسيط', triggers: ['type=settlement', 'hasMediator=true'], referenceArticle: 'قانون الوساطة'),
    LegalScenario(code: 'S059', titleAr: 'تنازل عن الدعاوى', category: 'عقود خاصة', descriptionAr: 'تنازل عن دعاوى قائمة', triggers: ['type=settlement'], referenceArticle: 'المادة 1047 مدني'),
    LegalScenario(code: 'S060', titleAr: 'عقد وصية', category: 'عقود خاصة', descriptionAr: 'عقد يتضمن وصية', triggers: ['type=inheritanceAgreement', 'will=true'], referenceArticle: 'المادة 169 مدني'),
    LegalScenario(code: 'S061', titleAr: 'شفعة', category: 'عقود خاصة', descriptionAr: 'دعوى شفعة', triggers: ['property_is_common_share=true'], referenceArticle: 'المادة 1042 مدني'),
    LegalScenario(code: 'S062', titleAr: 'وعد بالبيع', category: 'عقود خاصة', descriptionAr: 'عقد وعد ملزم', triggers: ['type=promise'], referenceArticle: 'المادة 156 مدني'),
    LegalScenario(code: 'S063', titleAr: 'تداخل عقود', category: 'عقود خاصة', descriptionAr: 'عقد مرتبط بعقد آخر', triggers: ['linked_contract=true'], referenceArticle: 'المادة 198 مدني'),
    LegalScenario(code: 'S064', titleAr: 'محضر متعدد الوحدات', category: 'محاضر', descriptionAr: 'محضر عقار به عدة وحدات', triggers: ['type=complexProperty'], referenceArticle: 'قانون الرسوم العقارية'),
    LegalScenario(code: 'S065', titleAr: 'استثناءات الوحدات', category: 'محاضر', descriptionAr: 'استثناء وحدتين من أصل عشرة', triggers: ['type=complexProperty', 'hasExceptions=true'], referenceArticle: 'المادة 558 مدني'),
    LegalScenario(code: 'S066', titleAr: 'بيع بحكم قضائي مبرم', category: 'قضائي', descriptionAr: 'بيع بموجب حكم مبرم', triggers: ['type=judicialSale', 'judgment_is_final=true'], referenceArticle: 'قانون التنفيذ'),
    LegalScenario(code: 'S067', titleAr: 'بيع بحكم غير مبرم', category: 'قضائي', descriptionAr: 'بيع بموجب حكم غير مبرم (تحت الطعن)', triggers: ['type=judicialSale', 'judgment_is_final=false'], referenceArticle: 'قانون التنفيذ'),
    LegalScenario(code: 'S068', titleAr: 'حصر إرث قضائي', category: 'قضائي', descriptionAr: 'محضر حصر إرث', triggers: ['type=judicialInheritance'], referenceArticle: 'قانون الأحوال الشخصية'),
    LegalScenario(code: 'S069', titleAr: 'قسمة قضائية', category: 'قضائي', descriptionAr: 'قسمة بأمر قضائي', triggers: ['type=judicialPartition'], referenceArticle: 'المادة 1010 مدني'),
    LegalScenario(code: 'S070', titleAr: 'تخارج قضائي', category: 'قضائي', descriptionAr: 'عقد تخارج بين الشركاء بأمر قضائي', triggers: ['type=judicialExit'], referenceArticle: 'المادة 855 مدني'),
    LegalScenario(code: 'S071', titleAr: 'بيع قاصر', category: 'بائع', descriptionAr: 'بائع قاصر مع إذن', triggers: ['seller_is_minor=true'], referenceArticle: 'قانون حماية القاصرين'),
    LegalScenario(code: 'S072', titleAr: 'بائع متوفى', category: 'بائع', descriptionAr: 'بائع متوفى', triggers: ['seller_is_deceased=true'], referenceArticle: 'قانون الإرث'),
    LegalScenario(code: 'S073', titleAr: 'بائع مفقود', category: 'بائع', descriptionAr: 'بائع مفقود', triggers: ['seller_is_missing=true'], referenceArticle: 'المادة 154 أحوال'),
    LegalScenario(code: 'S074', titleAr: 'بائع بوكالة', category: 'بائع', descriptionAr: 'بائع يتصرف بوكالة', triggers: ['seller_has_poa=true'], referenceArticle: 'المادة 837 مدني'),
    LegalScenario(code: 'S075', titleAr: 'قاصر مغترب', category: 'بائع', descriptionAr: 'بائع قاصر ومغترب', triggers: ['seller_is_minor=true', 'seller_is_expatriate=true'], referenceArticle: 'قانون حماية القاصرين'),
    LegalScenario(code: 'S076', titleAr: 'بائع مع وصية', category: 'بائع', descriptionAr: 'بائع ينفذ وصية', triggers: ['will=true'], referenceArticle: 'المادة 169 مدني'),
    LegalScenario(code: 'S077', titleAr: 'بائع مدين', category: 'بائع', descriptionAr: 'بائع عليه ديون', triggers: ['seller_has_debt=true'], referenceArticle: 'المادة 196 مدني'),
  ];

  static List<LegalScenario> byCategory(String category) =>
      all.where((s) => s.category == category).toList();

  static List<String> get categories => all.map((s) => s.category).toSet().toList();
}