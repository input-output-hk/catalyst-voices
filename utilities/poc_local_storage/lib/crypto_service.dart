import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';

final class CryptoService {
  static const int _ivLength = 12; // GCM standard IV length is 12 bytes
  static const int _saltLength = 16;
  static const int _keyLength = 32; // AES-256
  static const int _iterations = 100000; // Increased iterations for PBKDF2
  static const int _version = 1; // Versioning for future improvements

  final Random _random;

  CryptoService() : _random = Random.secure();

  Uint8List decrypt(
    Uint8List encryptedData,
    String password, {
    Uint8List? aad,
  }) {
    // Extract the version, salt, and IV
    final version = encryptedData[0];
    if (version != _version) {
      throw Exception('Unsupported version: $version');
    }

    final salt = encryptedData.sublist(1, 1 + _saltLength);
    final iv =
        encryptedData.sublist(1 + _saltLength, 1 + _saltLength + _ivLength);
    final data = encryptedData.sublist(1 + _saltLength + _ivLength);

    final key = _deriveKey(password, salt);

    final cipher = GCMBlockCipher(AESEngine());
    final aeadParams =
        AEADParameters(KeyParameter(key), 128, iv, aad ?? Uint8List(0));

    cipher.init(false, aeadParams);

    try {
      return cipher.process(data);
    } catch (e) {
      throw Exception('Decryption failed: $e');
    } finally {
      // Securely erase key from memory (if possible, platform dependent)
      _securelyErase(key);
    }
  }

  Uint8List encrypt(
    Uint8List data,
    String password, {
    Uint8List? aad,
  }) {
    final salt = _generateSalt();
    final key = _deriveKey(password, salt);
    final iv = _generateIV();

    final cipher = GCMBlockCipher(AESEngine());
    final aeadParams = AEADParameters(
      KeyParameter(key),
      128,
      iv,
      aad ?? Uint8List(0),
    );

    cipher.init(true, aeadParams);

    final encryptedData = cipher.process(data);

    // Combine version, salt, IV, and encrypted data
    return Uint8List.fromList([_version, ...salt, ...iv, ...encryptedData]);
  }

  Uint8List _deriveKey(String password, Uint8List salt) {
    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    final params = Pbkdf2Parameters(salt, _iterations, _keyLength);
    pbkdf2.init(params);
    final key = pbkdf2.process(utf8.encode(password));

    // Securely erase password from memory
    _securelyErase(Uint8List.fromList(utf8.encode(password)));

    return key;
  }

  Uint8List _generateIV() {
    return Uint8List.fromList(
      List.generate(
        _ivLength,
        (_) => _random.nextInt(256),
      ),
    );
  }

  Uint8List _generateSalt() {
    return Uint8List.fromList(
      List.generate(
        _saltLength,
        (_) => _random.nextInt(256),
      ),
    );
  }

  // Attempt to securely erase sensitive data from memory
  void _securelyErase(Uint8List data) {
    for (var i = 0; i < data.length; i++) {
      data[i] = 0;
    }
  }
}
