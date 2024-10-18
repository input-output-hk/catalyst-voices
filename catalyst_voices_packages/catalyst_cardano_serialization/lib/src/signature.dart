import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:equatable/equatable.dart';

/// The public and private Ed25519 key pair.
final class Ed25519KeyPair extends Equatable {
  /// The public key.
  final Ed25519PublicKey publicKey;

  /// The private key.
  final Ed25519PrivateKey privateKey;

  /// The default constructor for [Ed25519KeyPair].
  const Ed25519KeyPair({
    required this.publicKey,
    required this.privateKey,
  });

  /// Generates a [Ed25519KeyPair] from given private key [seed].
  static Future<Ed25519KeyPair> fromSeed(List<int> seed) async {
    if (seed.length != Ed25519PrivateKey.length) {
      throw ArgumentError(
        'Ed25519KeyPair seed length does not match: ${seed.length}',
      );
    }

    final algorithm = Ed25519();
    final keyPair = await algorithm.newKeyPairFromSeed(seed);
    final publicKey = await keyPair.extractPublicKey();
    final privateKey = await keyPair.extractPrivateKeyBytes();

    return Ed25519KeyPair(
      publicKey: Ed25519PublicKey.fromBytes(publicKey.bytes),
      privateKey: Ed25519PrivateKey.fromBytes(privateKey),
    );
  }

  @override
  List<Object?> get props => [publicKey, privateKey];
}

/// The ED25519 public key that is 256 bits long.
extension type Ed25519PublicKey._(List<int> bytes) {
  /// The length of the [Ed25519PublicKey] in bytes.
  static const int length = 32;

  /// The default constructor for [Ed25519PublicKey].
  Ed25519PublicKey.fromBytes(this.bytes) {
    if (bytes.length != length) {
      throw ArgumentError(
        'Ed25519PublicKey length does not match: ${bytes.length}',
      );
    }
  }

  /// Constructs [Ed25519PublicKey] from a hex [string].
  factory Ed25519PublicKey.fromHex(String string) {
    return Ed25519PublicKey.fromBytes(hex.decode(string));
  }

  /// Returns the [Ed25519PublicKey] filled with [byte] that can be
  /// used to reserve size to calculate the final transaction bytes size.
  factory Ed25519PublicKey.seeded(int byte) =>
      Ed25519PublicKey.fromBytes(List.filled(length, byte));

  /// Deserializes the type from cbor.
  factory Ed25519PublicKey.fromCbor(CborValue value) {
    return Ed25519PublicKey.fromBytes((value as CborBytes).bytes);
  }

  /// Serializes the type as cbor.
  CborValue toCbor({List<int> tags = const []}) {
    return CborBytes(bytes, tags: tags);
  }

  /// Returns a hex representation of the [Ed25519PublicKey].
  String toHex() => hex.encode(bytes);
}

/// The Ed25519 private key that is 256 bits long.
///
/// The [bytes] are the seed required by the Ed25519 algorithm.
extension type Ed25519PrivateKey._(List<int> bytes) {
  /// The length of the [Ed25519PrivateKey] in bytes.
  static const int length = 32;

  /// The default constructor for [Ed25519PrivateKey].
  Ed25519PrivateKey.fromBytes(this.bytes) {
    if (bytes.length != length) {
      throw ArgumentError(
        'Ed25519PrivateKey length does not match: ${bytes.length}',
      );
    }
  }

  /// Constructs [Ed25519PrivateKey] from a hex [string].
  factory Ed25519PrivateKey.fromHex(String string) {
    return Ed25519PrivateKey.fromBytes(hex.decode(string));
  }

  /// Returns the [Ed25519PrivateKey] filled with [byte] that can be
  /// used to reserve size to calculate the final transaction bytes size.
  factory Ed25519PrivateKey.seeded(int byte) =>
      Ed25519PrivateKey.fromBytes(List.filled(length, byte));

  /// Deserializes the type from cbor.
  factory Ed25519PrivateKey.fromCbor(CborValue value) {
    return Ed25519PrivateKey.fromBytes((value as CborBytes).bytes);
  }

  /// Serializes the type as cbor.
  CborValue toCbor() => CborBytes(bytes);

  /// Returns a hex representation of the [Ed25519PrivateKey].
  String toHex() => hex.encode(bytes);

  /// Signs the [message] with the private key and returns the signature.
  // 
  // TODO(dtscalac): it takes 200-300ms to execute, optimize it
  // or move to a JS web worker
  Future<Ed25519Signature> sign(List<int> message) async {
    final algorithm = Ed25519();
    final keyPair = await algorithm.newKeyPairFromSeed(bytes);
    final signature = await algorithm.sign(message, keyPair: keyPair);
    return Ed25519Signature.fromBytes(signature.bytes);
  }

  /// Returns a [Ed25519PublicKey] derived from this private key.
  Future<Ed25519PublicKey> derivePublicKey() async {
    final algorithm = Ed25519();
    final keyPair = await algorithm.newKeyPairFromSeed(bytes);
    final publicKey = await keyPair.extractPublicKey();
    return Ed25519PublicKey.fromBytes(publicKey.bytes);
  }
}

/// The witness signature of the transaction.
extension type Ed25519Signature._(List<int> bytes) {
  /// The length of the [Ed25519Signature] in bytes.
  static const int length = 64;

  /// The default constructor for [Ed25519Signature].
  Ed25519Signature.fromBytes(this.bytes) {
    if (bytes.length != length) {
      throw ArgumentError(
        'Ed25519Signature length does not match: ${bytes.length}',
      );
    }
  }

  /// Constructs [Ed25519Signature] from a hex [string].
  factory Ed25519Signature.fromHex(String string) {
    return Ed25519Signature.fromBytes(hex.decode(string));
  }

  /// Returns the [Ed25519Signature] filled with [byte]
  /// that can be used to reserve size.
  factory Ed25519Signature.seeded(int byte) =>
      Ed25519Signature.fromBytes(List.filled(length, byte));

  /// Deserializes the type from cbor.
  factory Ed25519Signature.fromCbor(CborValue value) {
    return Ed25519Signature.fromBytes((value as CborBytes).bytes);
  }

  /// Serializes the type as cbor.
  CborValue toCbor() => CborBytes(bytes);

  /// Returns a hex representation of the [Ed25519Signature].
  String toHex() => hex.encode(bytes);

  /// Returns true if this signature belongs to a given [publicKey]
  /// for given [message], false otherwise.
  Future<bool> verify(
    List<int> message, {
    required Ed25519PublicKey publicKey,
  }) async {
    final algorithm = Ed25519();
    return algorithm.verify(
      message,
      signature: Signature(
        bytes,
        publicKey: SimplePublicKey(publicKey.bytes, type: KeyPairType.ed25519),
      ),
    );
  }
}
