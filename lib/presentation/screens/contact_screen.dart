import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اتصل بنا')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _contactCard('البريد الإلكتروني', 'info@saeg-alouqoud.sy', Icons.email),
        _contactCard('الهاتف', '+963 11 123 4567', Icons.phone),
        _contactCard('العنوان', 'دمشق، سوريا', Icons.location_on),
        _contactCard('الموقع', 'www.saeg-alouqoud.sy', Icons.web),
      ]),
    );
  }

  Widget _contactCard(String label, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF1B4F72)),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}