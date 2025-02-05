import 'package:flutter/foundation.dart';

/// An abstract interface that defines cryptographic operations such as
/// key derivation, encryption, decryption, and key verification.
// TODO(damian-molinski): Expose KeyDerivation interface and have it
//  delegate implementation
abstract interface class CryptoService {
  /// Derives a cryptographic key from a given seed, with an optional salt.
  ///
  /// The derived key is generated based on the provided [seed], which serves
  /// as the primary input. Optionally, a [salt] can be used to further
  /// randomize the key derivation process, increasing security.
  ///
  /// - [seed]: The main input data used for key derivation.
  /// - [salt]: Optional salt value to randomize the derived key (can be null).
  ///
  /// Returns a [Future] that completes with the derived key as a [Uint8List].
  Future<Uint8List> deriveKey(
    Uint8List seed, {
    Uint8List? salt,
  });

  /// Verifies if a given cryptographic key is correctly derived from a seed.
  ///
  /// This method checks whether the provided [key] matches the key that would
  /// be derived from the given [seed]. This can be useful to verify integrity
  /// or correctness of the key derivation process.
  ///
  /// - [seed]: The input data used for key derivation.
  /// - [key]: The derived key that needs to be verified.
  ///
  /// Returns a [Future] that completes with `true` if the [key] is valid and
  /// correctly derived from the [seed], or `false` otherwise.
  Future<bool> verifyKey(
    Uint8List seed, {
    required Uint8List key,
  });

  /// Decrypts the provided [data] using the specified cryptographic [key],
  /// usually build using [deriveKey].
  ///
  /// This method takes encrypted [data] and decrypts it using the provided
  /// [key]. The decryption algorithm and the format of the data should be
  /// defined by the implementing class.
  ///
  /// - [data]: The encrypted data to be decrypted.
  /// - [key]: The key used for decryption.
  ///
  /// Returns a [Future] that completes with the decrypted data as a
  /// [Uint8List].
  Future<Uint8List> decrypt(
    Uint8List data, {
    required Uint8List key,
  });

  /// Encrypts the provided [data] using the specified cryptographic [key],
  /// usually build using [deriveKey].
  ///
  /// This method takes plaintext [data] and encrypts it using the provided
  /// [key]. The encryption algorithm and format of the output should be defined
  /// by the implementing class.
  ///
  /// - [data]: The plaintext data to be encrypted.
  /// - [key]: The key used for encryption.
  ///
  /// Returns a [Future] that completes with the encrypted data as a
  /// [Uint8List].
  Future<Uint8List> encrypt(
    Uint8List data, {
    required Uint8List key,
  });
}
