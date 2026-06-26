import 'package:flutter/material.dart';

class WarrantyScreen extends StatelessWidget {
  const WarrantyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إخلاء المسؤولية')),
      body: ListView(padding: const EdgeInsets.all(16), children: const [
        Card(
          color: Color(0xFFFEE),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('إخلاء المسؤولية القانونية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 16),
              Text(
                'هذا التطبيق أداة مساعدة للمحامين وأصحاب الاختصاص فقط. لا يُغني عن استشارة محامٍ مرخص، ولا يتحمل مطوّر التطبيق أي مسؤولية عن الأضرار الناتجة عن الاستخدام غير الصحيح.',
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 12),
              Text(
                'القوالب والتحذيرات والسيناريوهات مبنية على القانون السوري والفقه الإسلامي، لكنها عرضة للتغيير. يجب دائماً التحقق من النصوص القانونية النافذة.',
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 12),
              Text(
                'التحذيرات داخل التطبيق إرشادية فقط. العقد النهائي يجب أن يوقعه محامٍ مختص. المطور غير مسؤول عن أي ضرر ناتج.',
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 12),
              Text(
                'التطبيق يعمل أوفلاين بالكامل ولا يجمع أي بيانات شخصية. جميع البيانات مخزنة محلياً على جهازك.',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('للاستفسارات: info@saeg-alouqoud.sy', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
            ]),
          ),
        ),
      ]),
    );
  }
}