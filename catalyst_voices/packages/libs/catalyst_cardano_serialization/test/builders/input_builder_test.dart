import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:test/test.dart';

import '../test_utils/test_data.dart';
import '../test_utils/transaction_property_test_utils.dart';

void main() {
  final config = transactionBuilderConfig();

  group('$TransactionBuilder Coin Selection Tests', () {
    test('selectInputs should throw an exception if funds are insufficient', () {
      final builder = TransactionBuilder(config: config, inputs: const {});

      expect(
        builder.selectInputs,
        throwsA(isA<InsufficientUtxoBalanceException>()),
      );
    });

    group('Property-based tests for coin selection', () {
      transactionPropertyTest(
          'Coin selection should maintain accounting properties for '
          'various UTxO and output combinations', (data) {
        final builder = data.builder;

        expect(
          builder.selectInputs,
          anyOf(
            [
              returnsNormally,
              throwsA(isA<MaxTxSizeExceededException>()),
            ],
          ),
        );
      });

      transactionPropertyTest(
        'Transaction fee calculation should be consistent with the valid '
        'transaction fee across different UTxO and output combinations',
        (data) {
          final builder = data.builder;
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
    });
  });
}
