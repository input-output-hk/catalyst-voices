import 'package:catalyst_cardano_serialization/src/transaction.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:cbor/cbor.dart';

/// Calculates fees for the transaction on Cardano blockchain.
///
/// The fee is calculated using the following formula:
/// - `fee = constant + tx.bytes.len * coefficient`
final class LinearFee {
  /// The constant amount of [Coin] that is charged per transaction.
  final Coin constant;

  /// The amount of [Coin] per transaction byte that is charged per transaction.
  final Coin coefficient;

  /// The default constructor for the [LinearFee].
  /// The parameters are Cardano protocol parameters.
  const LinearFee({
    required this.constant,
    required this.coefficient,
  });

  /// Calculates the fee for the transaction denominated in lovelaces.
  ///
  /// The formula doesn't take into account smart contract scripts.
  Coin minNoScriptFee(Transaction tx) {
    final bytesCount = cbor.encode(tx.toCbor()).length;
    return Coin(bytesCount) * coefficient + constant;
  }
}
