import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as enc;

class LicenseService {
  static const _storage = FlutterSecureStorage();
  
  static const String _secretKeyString = "MySecretKeyArchivesApp2026!#Safe";
  static const String _fixedIV = "1234567890123456";

  // جلب معرّف الجهاز
  static Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    String rawId = "UNKNOWN_DEVICE";
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      rawId = androidInfo.id;
    }
    final bytes = utf8.encode(rawId);
    final digest = sha256.convert(bytes);
    return digest.toString().substring(0, 12).toUpperCase();
  }

  // فحص حالة التفعيل عند فتح التطبيق
  static Future<bool> isActivated() async {
    final savedKey = await _storage.read(key: 'license_key');
    if (savedKey == null) return false;

    final deviceId = await getDeviceId();
    final result = await verifyKey(savedKey, deviceId);
    return result['isValid'] == true;
  }

  // التحقق من صحة المفتاح ومقاومة التلاعب بالوقت
  static Future<Map<String, dynamic>> verifyKey(String key, String currentDeviceId) async {
    try {
      final keyBytes = enc.Key.fromUtf8(_secretKeyString);
      final iv = enc.IV.fromUtf8(_fixedIV);
      final encrypter = enc.Encrypter(enc.AES(keyBytes, mode: enc.AESMode.cbc));

      final decrypted = encrypter.decrypt64(key.trim(), iv: iv);
      final parts = decrypted.split('|');

      final keyDeviceId = parts[0];
      final type = parts[1];
      final expiryStr = parts[2];

      if (keyDeviceId != currentDeviceId) {
        return {'isValid': false, 'message': 'المفتاح غير مخصص لهذا الجهاز'};
      }

      // المفتاح الدائم لا يتأثر بالوقت
      if (type == 'LIFETIME') {
        return {'isValid': true, 'type': 'LIFETIME'};
      } 
      
      // المفتاح التجريبي: التحقق من التلاعب والانتهاء
      else if (type == 'TRIAL') {
        final expiryDate = DateTime.parse(expiryStr);
        final currentDate = await _getSecureDateTime();

        // 1. فحص التلاعب بالوقت (إرجاع التاريخ للوراء)
        final lastRecordedTimeStr = await _storage.read(key: 'last_recorded_time');
        if (lastRecordedTimeStr != null) {
          final lastRecordedTime = DateTime.parse(lastRecordedTimeStr);
          if (currentDate.isBefore(lastRecordedTime)) {
            return {
              'isValid': false,
              'message': 'تم اكتشاف تلاعب بتاريخ ووقت الهاتف! يرجى ضبط الساعة بدقة.'
            };
          }
        }

        // 2. فحص انتهاء مدة الـ 15 يوماً
        if (currentDate.isAfter(expiryDate)) {
          return {
            'isValid': false,
            'message': 'انتهت فترة التجربة (15 يوماً). يرجى الترقية إلى النسخة الدائمة.'
          };
        }

        // حفظ الوقت الحالي لمنع إرجاع الساعة لاحقاً
        await _storage.write(key: 'last_recorded_time', value: currentDate.toIso8601String());

        return {'isValid': true, 'type': 'TRIAL', 'expiry': expiryDate};
      }

      return {'isValid': false, 'message': 'مفتاح غير صالح'};
    } catch (e) {
      return {'isValid': false, 'message': 'كود التفعيل غير صحيح'};
    }
  }

  // محاولة جلب التوقيت الحقيقي من الإنترنت إذا وُجد اتصال، وإلا استخدام توقيت الجهاز
  static Future<DateTime> _getSecureDateTime() async {
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 2);
      // طلب خفيف جداً للهيدر فقط من خادم موثوق (مثل Google)
      final request = await client.headUrl(Uri.parse('https://www.google.com'));
      final response = await request.close();
      final dateHeader = response.headers.value(HttpHeaders.dateHeader);
      if (dateHeader != null) {
        return HttpDate.parse(dateHeader);
      }
    } catch (_) {
      // في حال عدم وجود إنترنت يعمل دون مقاطعة المستخدم
    }
    return DateTime.now();
  }

  // حفظ التفعيل
  static Future<void> saveLicense(String key) async {
    await _storage.write(key: 'license_key', value: key.trim());
    await _storage.write(key: 'last_recorded_time', value: DateTime.now().toIso8601String());
  }
}
