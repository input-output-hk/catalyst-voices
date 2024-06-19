import 'package:cbor/cbor.dart';

/// A hex-encoded string representing a registered DRep's ID which
/// is a Blake2b-224 hash digest of a 32 byte Ed25519 public key,
/// as described in [CIP-1694 Registered DReps](https://github.com/cardano-foundation/CIPs/blob/430f64d3e86dd67903a6bf1e611c06e5343072f3/CIP-1694/README.md#registered-dreps).
extension type DRepID(String value) {
  /// Deserializes the type from cbor.
  factory DRepID.fromCbor(CborValue value) {
    final bytes = (value as CborBytes).bytes;
    return DRepID(CborString.fromUtf8(bytes).toString());
  }

  /// Serializes the type as cbor.
  CborValue toCbor() => CborBytes(CborString(value).utf8Bytes);
}

/// A hex-encoded string representing 32 byte Ed25519 DRep public key,
/// as described in [CIP-0105 | Conway Era Key Chains for HD Wallets](https://github.com/cardano-foundation/CIPs/blob/master/CIP-0105/README.md).
extension type PubDRepKey(String value) {
  /// Deserializes the type from cbor.
  factory PubDRepKey.fromCbor(CborValue value) {
    final bytes = (value as CborBytes).bytes;
    return PubDRepKey(CborString.fromUtf8(bytes).toString());
  }

  /// Serializes the type as cbor.
  CborValue toCbor() => CborBytes(CborString(value).utf8Bytes);
}

/// A hex-encoded string representing 32 byte Ed25519
/// public key used as a staking credential.
extension type PubStakeKey(String value) {
  /// Deserializes the type from cbor.
  factory PubStakeKey.fromCbor(CborValue value) {
    final bytes = (value as CborBytes).bytes;
    return PubStakeKey(CborString.fromUtf8(bytes).toString());
  }

  /// Serializes the type as cbor.
  CborValue toCbor() => CborBytes(CborString(value).utf8Bytes);
}
