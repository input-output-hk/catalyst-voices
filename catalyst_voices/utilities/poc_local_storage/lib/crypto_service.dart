// ignore_for_file: inference_failure_on_instance_creation

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:pointycastle/export.dart';

/// A service for encrypting and decrypting data using AES-GCM.
final class CryptoService {
  /// GCM standard IV length is 12 bytes
  static const int _ivLength = 12;

  /// Salt length for Argon2 key derivation
  static const int _saltLength = 16;

  /// AES-256 key length
  static const int _keyLength = 32;

  /// Versioning for future improvements
  static const int _version = 1;

  final SecureRandom _secureRandom;

  factory CryptoService({SecureRandom? secureRandom}) {
    return CryptoService._(secureRandom ?? _initSecureRandom());
  }

  CryptoService._(this._secureRandom);

  /// Decrypts the [encryptedData] using the provided [password].
  Uint8List decrypt(
    Uint8List encryptedData,
    String password, {
    Uint8List? aad,
  }) {
    // Extract the version, algorithm ID, salt, and IV
    final version = encryptedData[0];
    final algorithmId = encryptedData[1];
    if (version != _version || algorithmId != 0x01) {
      throw Exception('Unsupported version or algorithm');
    }

    final salt = encryptedData.sublist(2, 2 + _saltLength);
    final iv = encryptedData.sublist(
      2 + _saltLength,
      2 + _saltLength + _ivLength,
    );
    final data = encryptedData.sublist(
      2 + _saltLength + _ivLength,
    );

    final key = _deriveKey(password, salt);

    final cipher = GCMBlockCipher(AESEngine());
    final aeadParams = AEADParameters(
      KeyParameter(key),
      128,
      iv,
      aad ?? Uint8List(0),
    );

    cipher.init(false, aeadParams);

    try {
      final decryptedData = cipher.process(data);

      // Verify checksum/marker
      final checksum = utf8.encode('CHK'); // 3-byte marker
      if (decryptedData.length < checksum.length) {
        throw Exception('Decrypted data is too short');
      }
      final originalData = decryptedData.sublist(
        0,
        decryptedData.length - checksum.length,
      );
      final extractedChecksum = decryptedData.sublist(
        decryptedData.length - checksum.length,
      );

      if (!const ListEquality().equals(checksum, extractedChecksum)) {
        throw Exception('Decryption failed: Checksum mismatch');
      }

      return originalData;
    } catch (e) {
      throw Exception('Decryption failed: $e');
    } finally {
      // Erase the key from memory
      _securelyErase(key);
    }
  }

  /// Encrypts the [data] using the provided [password].
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

    // Add a known marker or checksum at the end of the plaintext
    // before encryption
    final checksum = utf8.encode('CHK'); // 3-byte marker
    final combinedData = Uint8List.fromList([...data, ...checksum]);

    final encryptedData = cipher.process(combinedData);

    // Combine version, salt, IV, and encrypted data
    // Version 1, Algorithm ID 1 (AES-GCM)
    final metadata = Uint8List.fromList([_version, 0x01]);
    final result = Uint8List.fromList([
      ...metadata,
      ...salt,
      ...iv,
      ...encryptedData,
    ]);

    // Erase the key from memory
    _securelyErase(key);

    return result;
  }

  /// Hashes a password using Argon2id
  Uint8List hashPassword(String password, {Uint8List? salt}) {
    salt ??= _generateSalt();
    final argon2 = Argon2BytesGenerator();
    final params = Argon2Parameters(
      Argon2Parameters.ARGON2_id,
      salt,
      memoryPowerOf2: 12, // 12 MiB
      desiredKeyLength: _keyLength,
    );

    argon2.init(params);

    final passwordBytes = Uint8List.fromList(utf8.encode(password));
    final hashedPassword = argon2.process(passwordBytes);

    // Combine salt and hashed password for storage
    return Uint8List.fromList([...salt, ...hashedPassword]);
  }

  /// Re-encrypts the [encryptedData] using the provided [oldPassword]
  /// and [newPassword].
  Uint8List reEncrypt(
    Uint8List encryptedData,
    String oldPassword,
    String newPassword, {
    Uint8List? aad,
  }) {
    // Decrypt using the old password
    final decryptedData = decrypt(encryptedData, oldPassword, aad: aad);

    // Encrypt using the new password
    return encrypt(decryptedData, newPassword, aad: aad);
  }

  /// Verifies a password against a stored hash
  bool verifyPassword(String password, Uint8List storedHash) {
    final salt = storedHash.sublist(0, _saltLength);
    final hashedPassword = hashPassword(password, salt: salt);
    return const ListEquality().equals(hashedPassword, storedHash);
  }

  /// Derives a key from the [password] and [salt] using Argon2.
  /// Argon2 is a modern, secure key derivation function designed to resist
  /// brute-force attacks and side-channel attacks.
  Uint8List _deriveKey(String password, Uint8List salt) {
    final argon2 = Argon2BytesGenerator();
    final params = Argon2Parameters(
      Argon2Parameters.ARGON2_id,
      salt,
      memoryPowerOf2: 12, // 12 MiB
      desiredKeyLength: _keyLength,
    );

    argon2.init(params);

    // Convert the password to Uint8List
    final passwordBytes = Uint8List.fromList(utf8.encode(password));

    // Derive the key using the password and salt
    final key = argon2.process(passwordBytes);

    // Securely erase password from memory
    _securelyErase(Uint8List.fromList(utf8.encode(password)));

    return key;
  }

  /// Generates a random IV for AES-GCM.
  Uint8List _generateIV() {
    final iv = Uint8List(_ivLength);
    _secureRandom.nextBytes(iv.length);
    return iv;
  }

  /// Generates a random salt for Argon2.
  Uint8List _generateSalt() {
    final salt = Uint8List(_saltLength);
    _secureRandom.nextBytes(salt.length);
    return salt;
  }

  /// Attempts to securely erase sensitive data from memory.
  void _securelyErase(Uint8List data) => data.fillRange(0, data.length, 0);

  /// Initializes a secure random number generator.
  static SecureRandom _initSecureRandom() {
    final secureRandom = SecureRandom('Fortuna');
    final seed = Uint8List(32);

    for (var i = 0; i < seed.length; i++) {
      seed[i] = Random.secure().nextInt(256);
    }

    secureRandom.seed(KeyParameter(seed));
    return secureRandom;
  }
}
