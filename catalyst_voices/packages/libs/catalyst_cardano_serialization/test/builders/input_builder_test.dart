import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:kiri_check/kiri_check.dart';
import 'package:test/test.dart';

import '../test_utils/selection_utils.dart';

void main() {
  const config = SelectionUtils.defaultConfig;
  final changeAddress = SelectionUtils.randomAddress();

  group('$TransactionBuilder Coin Selection Tests', () {
    test('selectInputs should throw an exception if funds are insufficient',
        () {
      const builder = TransactionBuilder(config: config, inputs: {});

      expect(
        builder.selectInputs,
        throwsA(isA<InsufficientUtxoBalanceException>()),
      );
    });

    group('Property-based tests for coin selection', () {
      property(
          'Coin selection should maintain accounting properties for '
          'various UTxO and output combinations', () {
        forAll(
          maxExamples: 200,
          integer(min: 20, max: 500),
          (utxoCount) {
            final utxos = SelectionUtils.generateUtxos(
              utxoCount,
              minimumCoin: const Coin(15000000),
            );

            final outputs = SelectionUtils.outputsFromUTxos(
              inputs: utxos,
              maxOutputs: 10,
            );

            final builder = TransactionBuilder(
              config: config,
              inputs: utxos,
              outputs: outputs,
              changeAddress: changeAddress,
            );
            expect(
              builder.selectInputs,
              anyOf([
                returnsNormally,
                throwsA(isA<MaxTxSizeExceededException>()),
              ]),
            );
          },
        );
      });

      property(
        'Transaction fee calculation should be consistent with the valid '
        'transaction fee across different UTxO and output combinations',
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
  });
}
