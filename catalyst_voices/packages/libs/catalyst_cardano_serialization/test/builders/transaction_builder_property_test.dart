import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:test/test.dart';

import '../test_utils/test_data.dart';
import '../test_utils/transaction_property_test_utils.dart';

void main() {
  final config = transactionBuilderConfig(
    selectionStrategy: const ExactBiggestAssetSelectionStrategy(),
  );

  group(TransactionBuilder, () {
    transactionPropertyTest(
      'Transaction fee calculation should be consistent with the valid '
      'transaction fee across different UTxO and output combinations '
      'when using coin selection algorithm',
      config: transactionBuilderConfig(
        selectionStrategy: const ExactBiggestAssetSelectionStrategy(),
      ),
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

    transactionPropertyTest(
      'Transaction fee calculation should be consistent with the valid '
      'transaction fee across different UTxO and output combinations '
      'when consuming all inputs',
      config: transactionBuilderConfig(
        selectionStrategy: const ExactBiggestAssetSelectionStrategy(),
      ),
      (data) {
        final builder = data.builder;
        final appliedBuilder = builder.withChangeIfNeeded();
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
}
