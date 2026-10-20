import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/license_service.dart';
import 'home_screen.dart';

class ActivationScreen extends StatefulWidget {
  const ActivationScreen({super.key});

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  String _deviceId = "جاري التحميل...";
  final _keyController = TextEditingController();
  String _errorMessage = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDeviceId();
  }

  Future<void> _loadDeviceId() async {
    final id = await LicenseService.getDeviceId();
    if (mounted) {
      setState(() => _deviceId = id);
    }
  }

  void _activate() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    final result = await LicenseService.verifyKey(_keyController.text, _deviceId);

    if (result['isValid'] == true) {
      await LicenseService.saveLicense(_keyController.text);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } else {
      setState(() {
        _errorMessage = result['message'] ?? 'فشل التنشيط';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تنشيط التطبيق'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.security, size: 80, color: Colors.indigo),
            const SizedBox(height: 16),
            const Text(
              'أهلاً بك في نظام الأرشفة والسكرتارية',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('معرّف جهازك (أرسله لتلقي المفتاح):'),
                    const SizedBox(height: 8),
                    SelectableText(
                      _deviceId,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _deviceId));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم نسخ كود الجهاز')),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _keyController,
              decoration: InputDecoration(
                labelText: 'أدخل مفتاح التنشيط (تجريبي أو دائم)',
                border: const OutlineInputBorder(),
                errorText: _errorMessage.isEmpty ? null : _errorMessage,
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: _activate,
                    icon: const Icon(Icons.check_circle),
                    label: const Text('تفعيل التطبيق'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
