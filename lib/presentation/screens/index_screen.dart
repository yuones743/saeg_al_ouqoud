import 'package:flutter/material.dart';
import '../screens/index_screen.dart' as idx;

class AppIndexScreen extends StatelessWidget {
  const AppIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('فهرس الميزات')),
      body: idx.IndexScreen(onNavigate: () => Navigator.pop(context)),
    );
  }
}