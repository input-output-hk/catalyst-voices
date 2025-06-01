import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:kiri_check/kiri_check.dart';
import 'package:test/test.dart';

import '../test_utils/selection_utils.dart';
import '../test_utils/test_data.dart';

void main() {
  final config = transactionBuilderConfig(
    selectionStrategy: const ExactBiggestAssetSelectionStrategy(),
  );
  final changeAddress = SelectionUtils.randomAddress();

  group(TransactionBuilder, () {
    property(
      'Transaction fee calculation should be consistent with the valid '
      'transaction fee across different UTxO and output combinations '
      'when using coin selection algorithm',
      () {
        forAll(
          maxExamples: 200,
          integer(min: 40, max: 200),
          (utxoCount) {
            final utxos = SelectionUtils.generateUtxos(
              utxoCount,
              minimumCoin: const Coin(15000000),
            );

            final outputs = SelectionUtils.outputsFromUTxos(
              inputs: utxos,
              maxOutputs: 20,
            );

            final builder = TransactionBuilder(
              config: config,
              inputs: utxos,
              outputs: outputs,
              changeAddress: changeAddress,
            );

            final appliedBuilder = builder.applySelection();
            final txBody = appliedBuilder.buildBody();
            final calculatedFee = txBody.fee;

            final signedFakeTx = Transaction(
              body: txBody,
              isValid: true,
              witnessSet: TransactionBuilder.generateFakeWitnessSet(
                appliedBuilder.inputs,
                appliedBuilder.requiredSigners,
              ),
            );

            final validFee = config.feeAlgo.minFee(signedFakeTx, {
              ...builder.inputs,
              ...?builder.referenceInputs,
            });

            expect(
              calculatedFee,
              equals(validFee),
              reason: 'Calculated transaction fee should match the valid fee',
            );
          },
        );
      },
    );

    property(
      'Transaction fee calculation should be consistent with the valid '
      'transaction fee across different UTxO and output combinations '
      'when consuming all inputs',
      () {
        forAll(
          maxExamples: 150,
          integer(min: 40, max: 150),
          (utxoCount) {
            final utxos = SelectionUtils.generateUtxos(
              utxoCount,
              minimumCoin: const Coin(15000000),
            );

            final outputs = SelectionUtils.outputsFromUTxos(
              inputs: utxos,
              maxOutputs: 20,
            );

            final builder = TransactionBuilder(
              config: config,
              inputs: utxos,
              outputs: outputs,
              changeAddress: changeAddress,
            );

            final appliedBuilder = builder.withChangeAddressIfNeeded(changeAddress);
            final txBody = appliedBuilder.buildBody();
            final calculatedFee = txBody.fee;

            final signedFakeTx = Transaction(
              body: txBody,
              isValid: true,
              witnessSet: TransactionBuilder.generateFakeWitnessSet(
                appliedBuilder.inputs,
                appliedBuilder.requiredSigners,
              ),
            );

            final validFee = config.feeAlgo.minFee(signedFakeTx, {
              ...builder.inputs,
              ...?builder.referenceInputs,
            });

            expect(
              calculatedFee,
              equals(validFee),
              reason: 'Calculated transaction fee should match the valid fee',
            );
          },
        );
      },
    );
  });
}
