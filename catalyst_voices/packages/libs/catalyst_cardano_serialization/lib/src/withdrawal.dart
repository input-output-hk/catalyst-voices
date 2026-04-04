import 'package:catalyst_cardano_serialization/src/address.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:catalyst_cardano_serialization/src/utils/cbor.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

/// A map of reward account addresses to withdrawn [Coin] amounts.
///
/// Models the CDDL type:
/// ```cddl
/// withdrawals = { * reward_account => coin }
/// reward_account = bytes .size 29 ; 1 header byte (0xE0/0xF0) + 28 byte stake credential
/// ```
final class RewardAccountMap extends Equatable implements CborEncodable {
  /// The map of reward [ShelleyAddress]es to [Coin] amounts.
  ///
  /// Keys must be stake/reward addresses (bech32 prefix `stake` or `stake_test`),
  /// identified by a header byte of `0xE0` (mainnet) or `0xF0` (testnet),
  /// and exactly 29 bytes in length.
  final Map<ShelleyAddress, Coin> map;

  /// The default constructor for [RewardAccountMap].
  ///
  /// Throws [ArgumentError] if any key in [map] is not a valid reward address.
  RewardAccountMap({this.map = const {}}) {
    for (final address in map.keys) {
      if (!_isRewardAddress(address)) {
        throw ArgumentError(
          'RewardAccountMap address must be a reward/stake address '
          '(header 0xE0 or 0xF0, length 29): $address',
        );
      }
    }
  }

  /// Deserializes the type from CBOR.
  factory RewardAccountMap.fromCbor(CborValue value) {
    final cborMap = value as CborMap;
    return RewardAccountMap(
      map: {
        for (final entry in cborMap.entries)
          ShelleyAddress.fromCbor(entry.key): Coin.fromCbor(entry.value),
      },
    );
  }

  @override
  List<Object?> get props => [map];

  /// Serializes the type as CBOR.
  @override
  CborValue toCbor({List<int> tags = const []}) {
    return CborMap(
      {
        for (final entry in map.entries) entry.key.toCbor(): entry.value.toCbor(),
      },
      tags: map.isNotEmpty
          ? tags
          : [
              CborCustomTags.map,
              ...tags,
            ],
    );
  }

  /// Returns `true` if [address] is a reward/stake address.
  ///
  /// Reward addresses have a header byte of `0xE0` (mainnet) or `0xF0` (testnet)
  /// and are exactly [ShelleyAddress.entAddrLength] (29) bytes long.
  static bool _isRewardAddress(ShelleyAddress address) {
    final masked = address.bytes[0] & 0xF0;

    return address.bytes.length == ShelleyAddress.entAddrLength &&
        (masked == 0xE0 || masked == 0xF0);
    // (address.hrp == ShelleyAddress.defaultRewardHrp ||
    //  address.hrp == ShelleyAddress.defaultRewardHrp + ShelleyAddress.testnetHrpSuffix);
  }
}

/// `withdrawals = { + reward_account => coin }`
typedef Withdrawals = RewardAccountMap;

/// `direct_deposits = { + reward_account => coin }`
typedef DirectDeposits = RewardAccountMap;
