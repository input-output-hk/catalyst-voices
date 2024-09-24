import 'package:catalyst_cardano_serialization/src/exceptions.dart';
import 'package:catalyst_cardano_serialization/src/transaction.dart';
import 'package:catalyst_cardano_serialization/src/transaction_output.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

/// A final class that implements a flexible fee algorithm. It calculates
/// fees for transactions using both linear and tiered logic based on the
/// size of reference scripts.
///
/// If the [refScriptByteCost] parameter is `0` or if there are no reference
/// scripts in the `inputs`, then the [TieredFee] class behaves like the
/// pre-Conway linear fee model.
final class TieredFee extends Equatable {
  /// The constant amount of lovelace charged per transaction.
  ///
  /// This value is derived from the protocol parameter `minFeeA`.
  final int constant;

  /// The amount charged per transaction byte.
  ///
  /// This value is derived from the protocol parameter `minFeeB`.
  final int coefficient;

  /// The multiplier for the tiered fee algorithm.
  /// This factor increases the fee per byte at each size increment.
  ///
  /// For the Conway era, this value on mainnet is set to 1.2.
  final double multiplier;

  /// The size increment for the tiered fee algorithm.
  /// The fee per byte increases after this size.
  ///
  /// For the Conway era, this value on mainnet is set to 25,600 bytes.
  final int sizeIncrement;

  /// The cost per byte for reference scripts.
  /// This value is derived from the protocol parameter
  /// `minFeeRefScriptCostPerByte`.
  final int refScriptByteCost;

  /// The maximum size of reference scripts allowed per transaction.
  ///
  /// This value is currently hardcoded, but will be turned into an actual
  /// protocol parameter in the next era after Conway.
  ///
  /// For the Conway era, this value on mainnet is set to 204,800 bytes
  /// (200 KiB).
  final int maxRefScriptSize;

  /// The default constructor for [TieredFee], which applies both linear and
  /// tiered pricing based on transaction size.
  ///
  /// The parameters represent Cardano protocol values.
  /// > Note: The [multiplier], [sizeIncrement] and [maxRefScriptSize] are
  ///   currently hardcoded for mainnet but may become protocol parameters in
  ///   the future.
  const TieredFee({
    required this.constant,
    required this.coefficient,
    this.multiplier = 1.2,
    this.sizeIncrement = 25600,
    required this.refScriptByteCost,
    this.maxRefScriptSize = 204800,
  });

  /// Calculates the minimum fee for the transaction, adding any reference
  /// script-related costs if applicable.
  Coin minFee(Transaction tx, Set<TransactionUnspentOutput> inputs) {
    final refScriptsBytes = _calculateReferenceScriptSize(inputs);

    if (refScriptsBytes > maxRefScriptSize) {
      throw ReferenceScriptSizeLimitExceededException(maxRefScriptSize);
    }

    final minTxFee = tieredFee(
      cbor.encode(tx.toCbor()).length,
      refScriptsBytes,
    );

    return Coin(minTxFee);
  }

  /// Calculates the linear fee for a transaction based on its size in bytes.
  ///
  /// The linear fee formula is:
  /// - `fee = constant + (tx.bytes.len * coefficient)`
  ///
  /// > This formula does not account for smart contract scripts.
  int linearFee(int bytesCount) => bytesCount * coefficient + constant;

  /// Calculates the fee for a transaction using the tiered pricing model.
  /// This includes both the linear fee and, if applicable, a reference script
  /// fee.
  int tieredFee(int txBytes, int refScriptsBytes) {
    final txFee = linearFee(txBytes);
    final scriptFee = refScriptByteCost > 0 && refScriptsBytes > 0
        ? refScriptFee(
            multiplier,
            sizeIncrement,
            refScriptByteCost,
            refScriptsBytes,
          )
        : 0;
    return txFee + scriptFee;
  }

  /// Calculates the fee for the reference scripts.
  ///
  /// The reference script fee is based on a tiered pricing model:
  /// - The fee increases for each additional `25KiB` chunk of reference
  ///   script size.
  /// - The first `25KiB` is charged at a base cost per byte, and subsequent
  ///   chunks are charged at progressively higher rates, multiplied by `1.2`.
  int refScriptFee(
    double multiplier,
    int sizeIncrement,
    int refScriptCostPerByte,
    int resScriptSize,
  ) {
    int calcRefScriptFee(double acc, double curTierPrice, int n) =>
        n <= sizeIncrement
            ? (acc + n * curTierPrice).floor()
            : calcRefScriptFee(
                acc + curTierPrice * sizeIncrement,
                curTierPrice * multiplier,
                n - sizeIncrement,
              );
    return calcRefScriptFee(
      0,
      refScriptCostPerByte.toDouble(),
      resScriptSize,
    );
  }

  /// Calculates the total size of reference scripts used in a transaction.
  ///
  /// This includes the sizes of reference scripts from both inputs and
  /// reference inputs. Outputs without reference scripts do not contribute
  /// to the total size.
  ///
  /// Duplicate reference scripts are counted each time they appear in the
  /// transaction, i.e., when the same script is used on different inputs.
  ///
  /// However, any input that appears in both regular inputs and
  /// reference inputs of a transaction is only used once in this computation.
  int _calculateReferenceScriptSize(Set<TransactionUnspentOutput> inputs) {
    final totalSize = inputs.fold<int>(
      0,
      (prevSize, input) =>
          prevSize +
          switch (input.output) {
            final TransactionOutput output =>
              output.scriptRef != null ? output.scriptRef!.length : 0,
            _ => 0,
          },
    );

    return totalSize;
  }

  @override
  List<Object?> get props => [
        constant,
        coefficient,
        multiplier,
        sizeIncrement,
        refScriptByteCost,
        maxRefScriptSize,
      ];
}
