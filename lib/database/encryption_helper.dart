import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionHelper {
  // ✅ Kunci AES-256: tepat 32 karakter
  static final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows!'); // 32 chars
  // ✅ IV: tepat 16 karakter
  static final _iv = encrypt.IV.fromUtf8('1234567890abcdef'); // 16 chars

  static String encryptText(String? plainText) {
    if (plainText == null || plainText.isEmpty) {
      print('⚠️ EncryptText: input kosong');
      return '';
    }

    try {
      final encrypter = encrypt.Encrypter(
        encrypt.AES(_key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
      );
      final encrypted = encrypter.encrypt(plainText, iv: _iv);
      print('✅ EncryptText sukses: ${encrypted.base64}');
      return encrypted.base64;
    } catch (e) {
      print('❌ Encrypt error: $e');
      return '';
    }
  }

  static String decryptText(String? encryptedText) {
    if (encryptedText == null || encryptedText.isEmpty) {
      print('⚠️ DecryptText: input kosong');
      return '';
    }

    try {
      final encrypter = encrypt.Encrypter(
        encrypt.AES(_key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
      );
      final decrypted = encrypter.decrypt64(encryptedText, iv: _iv);
      print('✅ DecryptText sukses: $decrypted');
      return decrypted;
    } catch (e) {
      print('❌ Decrypt error: $e');
      return '';
    }
  }
}
