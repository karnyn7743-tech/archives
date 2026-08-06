import 'package:flutter/material.dart';
import 'models/register_category.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'الأرشفة الإدارية والسكرتارية',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomeScreen(), // توجيه التطبيق مباشرة إلى الشاشة الرئيسية المعرفة
    );
  }
}
