import 'package:catalyst_cardano_serialization/src/exceptions.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:equatable/equatable.dart';

/// An interface for classes that support CBOR serialization.
///
// ignore: one_member_abstracts
abstract interface class CborEncodable {
  /// Creates a new instance of [CborEncodable].
  const CborEncodable();

  /// Converts this instance to its CBOR representation.
  CborValue toCbor();
}

/// Specifies on which network the code will run.
enum NetworkId {
  /// The production network
  mainnet(id: 1),

  /// The test network.
  testnet(id: 0);

  /// The magic protocol number acting as the identifier of the network.
  final int id;

  const NetworkId({required this.id});

  factory NetworkId.fromId(int id) {
    for (final value in values) {
      if (value.id == id) {
        return value;
      }
    }

    throw ArgumentError('Unsupported NetworkId: $id');
  }
}

/// Specifies an amount of ADA in terms of lovelace.
extension type const Coin(int value) {
  /// The amount of lovelaces in one ADA.
  static const int adaInLovelaces = 1000000;

  /// Creates a [Coin] from [amount] specified in ADAs.
  factory Coin.fromAda(double amount) {
    return Coin((amount * adaInLovelaces).toInt());
  }

  /// Deserializes the type from cbor.
  factory Coin.fromCbor(CborValue value) {
    return Coin((value as CborSmallInt).value);
  }

  /// Serializes the type as cbor.
  CborValue toCbor() => CborSmallInt(value);

  /// Converts lovelaces to ADAs
  double get ada => value / adaInLovelaces;

  /// Adds [other] value to this value and returns a new [Coin].
  Coin operator +(Coin other) => Coin(value + other.value);

  /// Subtracts [other] values from this value and returns a new [Coin].
  Coin operator -(Coin other) => Coin(value - other.value);

  /// Multiplies this value by [other] values and returns a new [Coin].
  Coin operator *(Coin other) => Coin(value * other.value);

  /// Divides this value by [other] value without remainder
  /// and returns a new [Coin].
  Coin operator ~/(Coin other) => Coin(value ~/ other.value);

  /// Returns true if [value] is greater than [other] value.
  bool operator >(Coin other) => value > other.value;

  /// Returns true if [value] is greater than or equal [other] value.
  bool operator >=(Coin other) => value > other.value || value == other.value;

  /// Returns true if [value] is smaller than [other] value.
  bool operator <(Coin other) => value < other.value;

  /// Returns true if [value] is smaller than or equal [other] value.
  bool operator <=(Coin other) => value < other.value || value == other.value;
}

/// A blockchain slot number.
extension type const SlotBigNum(int value) {
  /// Deserializes the type from cbor.
  factory SlotBigNum.fromCbor(CborValue value) {
    return SlotBigNum((value as CborSmallInt).value);
  }

  /// Serializes the type as cbor.
  CborValue toCbor() => CborSmallInt(value);
}

/// Represents the balance of the wallet in terms of [Coin].
final class Balance extends Equatable implements CborEncodable {
  /// The amount of [Coin] that the wallet holds.
  final Coin coin;

  /// The amounts of native assets that the wallet holds.
  final MultiAsset? multiAsset;

  /// The default constructor for [Balance].
  const Balance({
    required this.coin,
    this.multiAsset,
  });

  /// Returns a zero [Balance] with no [coin] or [multiAsset].
  const Balance.zero()
      : coin = const Coin(0),
        multiAsset = null;

  /// Deserializes the type from cbor.
  factory Balance.fromCbor(CborValue value) {
    final CborValue coin;
    if (value is CborList) {
      coin = value.first;
    } else {
      coin = value;
    }

    final CborValue? multiAsset;
    if (value is CborList && value.length >= 2) {
      multiAsset = value[1];
    } else {
      multiAsset = null;
    }

    return Balance(
      coin: Coin.fromCbor(coin),
      multiAsset: multiAsset != null ? MultiAsset.fromCbor(multiAsset) : null,
    );
  }

  /// Serializes the type as cbor.
  @override
  CborValue toCbor() {
    final multiAsset = this.multiAsset;
    if (multiAsset == null) {
      return coin.toCbor();
    }

    return CborList([
      coin.toCbor(),
      multiAsset.toCbor(),
    ]);
  }

  /// Adds [other] value to this value and returns a new [Balance].
  Balance operator +(Balance other) {
    final MultiAsset? newMultiAsset;
    if (multiAsset == null && other.multiAsset == null) {
      newMultiAsset = null;
    } else {
      newMultiAsset = (multiAsset ?? const MultiAsset.empty()) +
          (other.multiAsset ?? const MultiAsset.empty());
    }

    final newCoin = coin + other.coin;
    return Balance(
      coin: newCoin,
      multiAsset: newMultiAsset,
    );
  }

  /// Subtracts [other] values from this value and returns a new [Balance].
  Balance operator -(Balance other) {
    final MultiAsset? newMultiAsset;
    if (multiAsset != null && other.multiAsset != null) {
      newMultiAsset = multiAsset! - other.multiAsset!;
    } else if (other.multiAsset != null) {
      throw const AssetDoesNotExistException();
    } else if (multiAsset != null) {
      newMultiAsset = multiAsset;
    } else {
      newMultiAsset = null;
    }

    final newCoin = coin - other.coin;
    return Balance(
      coin: newCoin,
      multiAsset: newMultiAsset,
    );
  }

  /// Returns true if
  bool get isZero => coin == const Coin(0) && !hasMultiAssets();

  /// Returns true if at least one native asset with non-zero amount exists.
  bool hasMultiAssets() {
    final multiAsset = this.multiAsset;
    if (multiAsset == null) return false;

    for (final policy in multiAsset.bundle.entries) {
      for (final asset in policy.value.entries) {
        if (asset.value != const Coin(0)) return true;
      }
    }

    return false;
  }

  /// Return a copy of this value with [coin] and [multiAsset] if present.
  Balance copyWith({
    Coin? coin,
    MultiAsset? multiAsset,
  }) {
    return Balance(
      coin: coin ?? this.coin,
      multiAsset: multiAsset ?? this.multiAsset,
    );
  }

  @override
  List<Object?> get props => [coin, multiAsset];
}

/// Holds native assets minted with [PolicyId].
final class MultiAsset extends Equatable implements CborEncodable {
  /// The map of native assets.
  ///
  /// The [Coin] is used to describe the amount of native assets
  /// the wallet holds but they are not Ada or Lovelace,
  /// instead these native assets should be referred to as [AssetName].
  final Map<PolicyId, Map<AssetName, Coin>> bundle;

  /// The default constructor for [MultiAsset].
  const MultiAsset({
    required this.bundle,
  });

  /// Returns an empty [MultiAsset].
  const MultiAsset.empty() : this(bundle: const {});

  /// Deserializes the type from cbor.
  factory MultiAsset.fromCbor(CborValue value) {
    final map = value as CborMap;
    final bundle = <PolicyId, Map<AssetName, Coin>>{};

    for (final policy in map.entries) {
      final policyId = PolicyId.fromCbor(policy.key);
      final cborAssets = policy.value as CborMap;
      final assets = <AssetName, Coin>{};

      for (final asset in cborAssets.entries) {
        final assetName = AssetName.fromCbor(asset.key);
        final coin = Coin.fromCbor(asset.value);
        assets[assetName] = coin;
      }

      bundle[policyId] = assets;
    }

    return MultiAsset(bundle: bundle);
  }

  /// Serializes the type as cbor.
  @override
  CborValue toCbor() {
    return CborMap({
      for (final policy in bundle.entries)
        policy.key.toCbor(): CborMap({
          for (final asset in policy.value.entries)
            asset.key.toCbor(): asset.value.toCbor(),
        }),
    });
  }

  /// Adds [other] value to this value and returns a new [MultiAsset].
  MultiAsset operator +(MultiAsset other) {
    final bundleCopy = Map.of(bundle);
    for (final policy in other.bundle.entries) {
      final assets = Map.of(bundleCopy[policy.key] ?? <AssetName, Coin>{});
      for (final asset in policy.value.entries) {
        assets[asset.key] = (assets[asset.key] ?? const Coin(0)) + asset.value;
      }
      bundleCopy[policy.key] = assets;
    }

    return MultiAsset(bundle: bundleCopy);
  }

  /// Subtracts [other] values from this value and returns a new [MultiAsset].
  MultiAsset operator -(MultiAsset other) {
    final bundleCopy = Map.of(bundle);
    for (final policy in other.bundle.entries) {
      final assets = Map.of(bundleCopy[policy.key] ?? <AssetName, Coin>{});
      for (final asset in policy.value.entries) {
        final currentAssetValue = assets[asset.key];
        if (currentAssetValue == null) {
          throw const AssetDoesNotExistException();
        } else if (currentAssetValue == asset.value) {
          assets.remove(asset.key);
        } else {
          assets[asset.key] = currentAssetValue - asset.value;
        }
      }

      if (assets.isEmpty) {
        bundleCopy.remove(policy.key);
      } else {
        bundleCopy[policy.key] = assets;
      }
    }

    return MultiAsset(bundle: bundleCopy);
  }

  @override
  List<Object?> get props => [bundle];
}

/// The hash of policy ID that minted native assets.
extension type PolicyId(String hash) {
  /// Deserializes the type from cbor.
  factory PolicyId.fromCbor(CborValue value) {
    return PolicyId(hex.encode((value as CborBytes).bytes));
  }

  /// Serializes the type as cbor.
  CborValue toCbor() => CborBytes(hex.decode(hash));
}

/// The name of a native asset.
extension type AssetName(String name) {
  /// Deserializes the type from cbor.
  factory AssetName.fromCbor(CborValue value) {
    final bytes = (value as CborBytes).bytes;
    // FIXME(ilap): Handle non ASCII/UTF-8 characters.
    return AssetName(CborString.fromUtf8(bytes).toString(allowMalformed: true));
  }

  /// Serializes the type as cbor.
  CborValue toCbor() => CborBytes(CborString(name).utf8Bytes);
}
