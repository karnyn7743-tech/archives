import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'dart:io';

class LicenseService {
  static const _storage = FlutterSecureStorage();
  
  // مفتاح سري خاص بك أنت فقط - بطول 32 حرفاً تماماً
  static const String _secretKeyString = "MySecretKeyArchivesApp2026!#Safe"; 

  // جلب معرّف الجهاز الفريد
  static Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    String rawId = "UNKNOWN_DEVICE";
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      rawId = androidInfo.id;
    }
    // تحويل المعرّف لكود أقصر وسهل القراءة
    final bytes = utf8.encode(rawId);
    final digest = sha256.convert(bytes);
    return digest.toString().substring(0, 12).toUpperCase();
  }

  // التحقق من حالة التفعيل الحالية
  static Future<bool> isActivated() async {
    final savedKey = await _storage.read(key: 'license_key');
    if (savedKey == null) return false;

    final deviceId = await getDeviceId();
    final result = verifyKey(savedKey, deviceId);
    return result['isValid'] == true;
  }

  // فحص الكود المدخل
  static Map<String, dynamic> verifyKey(String key, String currentDeviceId) {
    try {
      final keyBytes = enc.Key.fromUtf8(_secretKeyString);
      final iv = enc.IV.fromLength(16);
      final encrypter = enc.Encrypter(enc.AES(keyBytes, mode: enc.AESMode.cbc));

      final decrypted = encrypter.decrypt64(key.trim(), iv: iv);
      final parts = decrypted.split('|');
      // التنسيق: DEVICE_ID|TYPE|EXPIRY_DATE
      // مثال: A1B2C3D4E5F6|TRIAL|2026-11-05
      // أو:  A1B2C3D4E5F6|LIFETIME|NONE

      final keyDeviceId = parts[0];
      final type = parts[1];
      final expiryStr = parts[2];

      if (keyDeviceId != currentDeviceId) {
        return {'isValid': false, 'message': 'المفتاح غير مخصص لهذا الجهاز'};
      }

      if (type == 'LIFETIME') {
        return {'isValid': true, 'type': 'LIFETIME'};
      } else if (type == 'TRIAL') {
        final expiryDate = DateTime.parse(expiryStr);
        if (DateTime.now().isAfter(expiryDate)) {
          return {'isValid': false, 'message': 'انتهت فترة التجربة (15 يوماً)'};
        }
        return {'isValid': true, 'type': 'TRIAL', 'expiry': expiryDate};
      }

      return {'isValid': false, 'message': 'مفتاح غير صالح'};
    } catch (e) {
      return {'isValid': false, 'message': 'كود التفعيل غير صحيح'};
    }
  }

  // حفظ التفعيل
  static Future<void> saveLicense(String key) async {
    await _storage.write(key: 'license_key', value: key.trim());
  }
}
