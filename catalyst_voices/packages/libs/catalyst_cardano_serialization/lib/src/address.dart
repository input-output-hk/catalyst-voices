// Copyright 2021 Richard Easterling
// SPDX-License-Identifier: Apache-2.0

// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

import 'package:bip32_ed25519/bip32_ed25519.dart';
import 'package:catalyst_cardano_serialization/src/exceptions.dart';
import 'package:catalyst_cardano_serialization/src/hashes.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

/// [ShelleyAddress] supports bech32 encoded addresses as defined in CIP-19.
class ShelleyAddress extends Equatable implements CborEncodable {
  /// The prefix of a base address.
  static const String defaultAddrHrp = 'addr';

  /// The prefix of a stake/reward address.
  static const String defaultRewardHrp = 'stake';

  /// The hrp suffix of an address on testnet network.
  static const String testnetHrpSuffix = '_test';

  static const Bech32Encoder _mainNetEncoder =
      Bech32Encoder(hrp: defaultAddrHrp);
  static const Bech32Encoder _testNetEncoder =
      Bech32Encoder(hrp: defaultAddrHrp + testnetHrpSuffix);
  static const Bech32Encoder _mainNetRewardEncoder =
      Bech32Encoder(hrp: defaultRewardHrp);
  static const Bech32Encoder _testNetRewardEncoder =
      Bech32Encoder(hrp: defaultRewardHrp + testnetHrpSuffix);

  /// Length of a Cardano base address (1 byte + 28 bytes + 28 bytes).
  static const int baseAddrLength = 57;

  /// Length of a Cardano enterprise address (1 byte + 28 bytes).
  static const int entAddrLength = 29;

  /// Raw bytes of address.
  /// Format [ 8 bit header | payload ]
  final Uint8List bytes;

  /// The prefix specifying the address type and networkId.
  final String hrp;

  /// The constructor for [ShelleyAddress] from raw [bytes] and [hrp].
  ShelleyAddress(List<int> bytes)
      : bytes = Uint8List.fromList(bytes),
        hrp = _extractHrp(bytes) {
    if (bytes.length != entAddrLength && bytes.length != baseAddrLength) {
      throw ArgumentError(
        'Bytes length (${bytes.length}) must be either $entAddrLength'
        ' or $baseAddrLength.',
      );
    }
  }

  /// The constructor which parses the address from bech32 format.
  factory ShelleyAddress.fromBech32(String address) {
    final hrp = _hrpPrefix(address);
    if (hrp.isEmpty) {
      throw InvalidAddressException(
        'not a valid Bech32 address - no prefix: $address',
      );
    }

    switch (hrp) {
      case defaultAddrHrp:
        return ShelleyAddress(_mainNetEncoder.decode(address));
      case const (defaultAddrHrp + testnetHrpSuffix):
        return ShelleyAddress(_testNetEncoder.decode(address));
      case defaultRewardHrp:
        return ShelleyAddress(_mainNetRewardEncoder.decode(address));
      case const (defaultRewardHrp + testnetHrpSuffix):
        return ShelleyAddress(_testNetRewardEncoder.decode(address));
      default:
        return ShelleyAddress(
          Bech32Encoder(hrp: hrp).decode(address),
        );
    }
  }

  /// Deserializes the type from cbor.
  factory ShelleyAddress.fromCbor(CborValue value) {
    return ShelleyAddress((value as CborBytes).bytes);
  }

  /// Serializes the type as cbor.
  @override
  CborValue toCbor() => CborBytes(bytes);

  /// Returns the [NetworkId] related to this address.
  NetworkId get network => _extractNetworkId(bytes);

  /// Returns the [Ed25519PublicKeyHash] contained in this address.
  ///
  /// Practically it's the address without the header byte.
  Ed25519PublicKeyHash get publicKeyHash => _extractPublicKeyHash(bytes);

  /// Encodes the address in bech32 format.
  String toBech32() {
    final prefix = _computeHrp(network, hrp);
    switch (prefix) {
      case defaultAddrHrp:
        return _mainNetEncoder.encode(bytes);
      case const (defaultAddrHrp + testnetHrpSuffix):
        return _testNetEncoder.encode(bytes);
      case defaultRewardHrp:
        return _mainNetRewardEncoder.encode(bytes);
      case const (defaultRewardHrp + testnetHrpSuffix):
        return _testNetRewardEncoder.encode(bytes);
      default:
        return Bech32Encoder(hrp: prefix).encode(bytes);
    }
  }

  @override
  int get hashCode => Object.hash(bytes, hrp);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ShelleyAddress) return false;
    if (bytes.length != other.bytes.length) return false;
    if (hrp != other.hrp) return false;

    for (var i = 0; i < bytes.length; i++) {
      if (bytes[i] != other.bytes[i]) return false;
    }
    return true;
  }

  @override
  String toString() => toBech32();

  @override
  List<Object?> get props => [toBech32()];

  /// If were using the testnet, make sure the hrp ends with '_test'
  static String _computeHrp(NetworkId id, String prefix) {
    if (id == NetworkId.mainnet) {
      return prefix;
    } else if (prefix.endsWith(testnetHrpSuffix)) {
      return prefix;
    } else {
      return prefix + testnetHrpSuffix;
    }
  }

  static String _hrpPrefix(String addr) {
    final s = addr.trim();
    final i = s.indexOf('1');
    return s.substring(0, i > 0 ? i : 0);
  }

  static String _extractHrp(List<int> bytes) {
    final header = bytes[0];
    switch (header & 0xF0) {
      case 0xE0:
      case 0xF0:
        return _computeHrp(_extractNetworkId(bytes), defaultRewardHrp);
      default:
        return _computeHrp(_extractNetworkId(bytes), defaultAddrHrp);
    }
  }

  static NetworkId _extractNetworkId(List<int> bytes) {
    return NetworkId.testnet.id == (bytes[0] & 0x0f)
        ? NetworkId.testnet
        : NetworkId.mainnet;
  }

  /// Extracts the payload from [bytes].
  ///
  /// Format [ 8 bit header | payload ]
  static Ed25519PublicKeyHash _extractPublicKeyHash(List<int> bytes) =>
      Ed25519PublicKeyHash.fromBytes(
        bytes: bytes.sublist(1, Ed25519PublicKeyHash.hashLength + 1),
      );
}
