import 'package:catalyst_cardano_serialization/src/builders/transaction_builder.dart';
import 'package:catalyst_cardano_serialization/src/transaction.dart';
import 'package:catalyst_cardano_serialization/src/transaction_output.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:test/test.dart';

/// Validates that the fee in the given [transaction] has been calculated correctly
/// according to the [builder]'s fee algorithm and UTxO configuration.
///
/// This function simulates a test [expect] to ensure that:
///
/// - The fee is at least the minimum fee required by the fee algorithm.
/// - If the fee is more than the minimum and a change output is present, it's incorrect to
///   burn the leftover ADA as a fee.
/// - If there is no change output, the leftover ADA may be burned **only** if it's too small
///   to justify creating a new change output.
///
/// Fails the test using [fail] if:
///
/// - The actual fee is less than the minimum valid fee.
/// - There is a change output, but the fee is higher than the minimum (implying ADA is burned unnecessarily).
/// - The leftover ADA (fee - valid fee) is enough to create a valid change output, but wasn't used.
void verifyTransactionFee(Transaction transaction, TransactionBuilder builder) {
  final calculatedFee = transaction.body.fee;

  final validFee = builder.config.feeAlgo.minFee(transaction, {
    ...builder.inputs,
    ...?builder.referenceInputs,
  });

  if (calculatedFee < validFee) {
    fail('Actual fee: $calculatedFee, expected: $validFee');
  } else if (calculatedFee == validFee) {
    // Calculated fee is the minimum fee, correct!
  } else if (builder.hasChangeOutputs) {
    fail('Any leftover ada should be included in the changed output, not burned as a fee.'
        ' Expected fee: $validFee, got: $calculatedFee');
  } else {
    final leftoverAda = calculatedFee - validFee;
    final minAda = builder.calculateAdaAmountToIncludeChangeOutput(leftoverAda);

    if (leftoverAda > minAda) {
      fail(
        'The leftover ada: $leftoverAda is enough to create extra transaction'
        ' output with change: $minAda, instead it was burned as fee',
      );
    } else {
      // The leftover ada is not enough to create extra
      // change output, burning it as a fee is correct.
    }
  }
}

extension on TransactionBuilder {
  bool get hasChangeOutputs {
    return outputs.any((e) => e.address == changeAddress);
  }

  /// Calculates the price we need to pay to include extra output with [leftoverAda].
  Coin calculateAdaAmountToIncludeChangeOutput(Coin leftoverAda) {
    final changeOutput = PreBabbageTransactionOutput(
      address: changeAddress!,
      amount: Balance(coin: leftoverAda),
    );

    final feeForOutput = TransactionOutputBuilder.feeForOutput(config, changeOutput);

    final minAdaForOutput = TransactionOutputBuilder.minimumAdaForOutput(
      changeOutput,
      config.coinsPerUtxoByte,
    );

    return feeForOutput + minAdaForOutput;
  }
}
