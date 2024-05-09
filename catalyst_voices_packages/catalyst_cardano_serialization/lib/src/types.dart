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
}

/// Specifies an amount of ADA in terms of lovelace.
extension type Coin(int value) {
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
extension type SlotBigNum(int value) {
  /// Serializes the type as cbor.
  CborValue toCbor() => CborSmallInt(value);
}
