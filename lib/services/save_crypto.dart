import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../config/secrets.dart';

/// Simple HMAC-tag + Base64 wrapper for save payloads.
/// This is tamper-evidence (not strong encryption); for true encrypted
/// saves, swap to package:encrypt AES-CBC using [Secrets.saveEncryptionKeyBase64].
class SaveCrypto {
  SaveCrypto._();

  static String _key() => Secrets.saveEncryptionKeyBase64;

  /// Returns "payload.sig" — payload is base64 of plaintext JSON,
  /// sig is HMAC-SHA256(payload).
  static String sign(String plaintext) {
    final payload = base64Url.encode(utf8.encode(plaintext));
    final hmac = Hmac(sha256, utf8.encode(_key()));
    final sig = base64Url.encode(hmac.convert(utf8.encode(payload)).bytes);
    return '$payload.$sig';
  }

  /// Verify + decode. Returns null if signature invalid.
  static String? verify(String signed) {
    final parts = signed.split('.');
    if (parts.length != 2) return null;
    final hmac = Hmac(sha256, utf8.encode(_key()));
    final expected = base64Url.encode(hmac.convert(utf8.encode(parts[0])).bytes);
    if (expected != parts[1]) return null;
    return utf8.decode(base64Url.decode(parts[0]));
  }
}
