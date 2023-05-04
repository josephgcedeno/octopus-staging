import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:octopus/infrastructures/models/hr/hr_response.dart';
import 'package:octopus/internal/class_parse_object.dart';

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

  Credential decryptCredential(
    AccountCredentialsParseObject encrptedCredentials,
  ) =>
      Credential(
        accountType: encrptedCredentials.accountType,
        id: encrptedCredentials.objectId!,
        password: decrypt(encrptedCredentials.password),
        username: encrptedCredentials.username,
      );
}
