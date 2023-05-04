import 'dart:convert';
import 'package:encrypt/encrypt.dart';

class EncryptionService {
  EncryptionService(String key) {
    this.key = Key.fromUtf8(
      key,
    );
    _iv = IV.fromLength(16);
  }
  late final Key key;
  late final IV _iv;

  late final Encrypter _encrypter = Encrypter(AES(key));

  String encrypt(String data) {
    final Encrypted encrypted = _encrypter.encrypt(data, iv: _iv);
    return base64.encode(encrypted.bytes);
  }

  String decrypt(String data) {
    final String decrypted = _encrypter.decrypt64(data, iv: _iv);
    return decrypted;
  }
}
