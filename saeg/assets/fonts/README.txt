# ملفات الخطوط العربية المطلوبة

يطلب التطبيق وجود الملفات التالية في هذا المجلد لعرض النصوص العربية بشكل صحيح:

1. TraditionalArabic.ttf  (الخط الأساسي - الأكثر أهمية)
2. Amiri-Regular.ttf
3. Amiri-Bold.ttf
4. Cairo-Regular.ttf
5. Cairo-Bold.ttf
6. NotoNaskhArabic-Regular.ttf
7. NotoNaskhArabic-Bold.ttf
8. Lateef-Regular.ttf

يمكن تنزيل هذه الخطوط من:
- Google Fonts: https://fonts.google.com
  - Amiri: https://fonts.google.com/specimen/Amiri
  - Cairo: https://fonts.google.com/specimen/Cairo
  - Noto Naskh Arabic: https://fonts.google.com/noto/specimen/Noto+Naskh+Arabic
  - Lateef: https://fonts.google.com/specimen/Lateef
- Traditional Arabic: مدمج في Windows أو يمكن تنزيله من مواقع الخطوط العربية

## السلوك عند غياب الخطوط

إذا لم تتوفر ملفات الخطوط:
1. يحاول التطبيق استخدام TraditionalArabic.ttf كخط احتياطي أول
2. إذا لم يتوفر، يستخدم خط Times المدمج في مكتبة pdf
3. يظهر إشعار SnackBar برتقالي اللون في شاشة المعاينة يُنبّه المستخدم
   بأن الخط المحدد غير متوفر وتم استخدام البديل

لا تؤثر هذه الحالة على عمل التطبيق - يعمل بشكل كامل مع الخط البديل.
