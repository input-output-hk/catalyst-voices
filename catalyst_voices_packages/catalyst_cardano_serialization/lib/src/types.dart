import 'package:cbor/cbor.dart';

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
  /// Deserializes the type from cbor.
  factory Coin.fromCbor(CborValue value) {
    return Coin((value as CborSmallInt).value);
  }

  /// Serializes the type as cbor.
  CborValue toCbor() => CborSmallInt(value);

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
///
/// For now, other assets than Ada are not supported and are ignored.
final class Value {
  /// The [amount] of [Coin] that the wallet holds.
  final Coin amount;

  /// The default constructor for [Value].
  const Value({
    required this.amount,
  });

  /// Deserializes the type from cbor.
  factory Value.fromCbor(CborValue value) {
    final CborValue amount;
    if (value is CborList) {
      amount = value.first;
    } else {
      amount = value;
    }

    return Value(
      amount: Coin.fromCbor(amount),
    );
  }

  /// Serializes the type as cbor.
  CborValue toCbor() => amount.toCbor();
}
