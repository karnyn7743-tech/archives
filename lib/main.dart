import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/activation_screen.dart';
import 'services/license_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // فحص حالة التفعيل قبل بناء الواجهات
  final bool activated = await LicenseService.isActivated();

  runApp(MyApp(isActivated: activated));
}

class MyApp extends StatelessWidget {
  final bool isActivated;
  const MyApp({Key? key, required this.isActivated}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'الأرشفة الإدارية والسكرتارية',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      // إذا كان مفعلاً يتجه للشاشة الرئيسية مباشرة، وإلا يتجه لشاشة التنشيط
      home: isActivated ? const HomeScreen() : const ActivationScreen(),
    );
  }
}
