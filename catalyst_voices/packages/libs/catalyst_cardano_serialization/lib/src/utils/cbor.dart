/// Holds cbor tags not specified by the official cbor package.
final class CborCustomTags {
  const CborCustomTags._();

  /// A cbor tag describing a uuid.
  static const int uuid = 37;

  /// A cbor tag describing a key-value pairs data.
  static const int map = 259;

  /// A cbor tag describing a ED25519-BIP32 Public Key.
  static const int ed25519Bip32PublicKey = 32773;
}

/// How many bytes are used in cbor encoding for a major type/length.
enum CborSize {
  /// Length/data is encoded inside of the type information.
  inline(bytes: 0),

  /// Length/data is in 1 byte following the type information.
  one(bytes: 1),

  /// Length/data is in 2 bytes following the type information.
  two(bytes: 2),

  /// Length/data is in 4 bytes following the type information.
  four(bytes: 4),

  /// Length/data is in 8 bytes following the type information.
  eight(bytes: 8);

  /// The amount of bytes it takes to encode the type in cbor.
  final int bytes;

  const CborSize({required this.bytes});

  /// The max int value that can be inlined in cbor without extra bytes.
  static const int maxInlineEncoding = 23;

  /// Calculates the [CborSize] for arbitrary [value].
  static CborSize ofInt(int value) {
    if (value <= maxInlineEncoding) {
      return CborSize.inline;
    } else if (value < 0x100) {
      return CborSize.one;
    } else if (value < 0x10000) {
      return CborSize.two;
    } else if (value < 0x100000000) {
      return CborSize.four;
    } else {
      return CborSize.eight;
    }
  }
}
