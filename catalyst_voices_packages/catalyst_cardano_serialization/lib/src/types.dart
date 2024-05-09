import 'package:cbor/cbor.dart';

/// Specifies an amount of ADA in terms of lovelace.
typedef Coin = int;

/// Specifies on which network the code will run.
enum NetworkId {
  /// The production network
  mainnet(magicId: 1),

  /// The test network.
  testnet(magicId: 0);

  /// The magic protocol number acting as the identifier of the network.
  final int magicId;

  const NetworkId({required this.magicId});
}

/// A blockchain slot number.
extension type SlotBigNum(int value) {
  /// Serializes the type as cbor.
  CborValue toCbor() {
    return CborSmallInt(value);
  }
}
