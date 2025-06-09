import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:test/test.dart';

import '../test_utils/fee_utils.dart';
import '../test_utils/test_data.dart';
import '../test_utils/transaction_property_test_utils.dart';

void main() {
  group(TransactionBuilder, () {
    transactionPropertyTest(
      'Transaction fee calculation should be consistent with the valid '
      'transaction fee across different UTxO and output combinations '
      'when using coin selection algorithm',
      config: transactionBuilderConfig(
        selectionStrategy: const ExactBiggestAssetSelectionStrategy(),
      ),
      (data) {
        final builder = data.builder.applySelection();
        final txBody = builder.buildBody();

        final transaction = Transaction(
          body: txBody,
          isValid: true,
          witnessSet: TransactionBuilder.generateFakeWitnessSet(
            builder.inputs,
            builder.requiredSigners,
          ),
          auxiliaryData: builder.auxiliaryData,
        );

        verifyTransactionFee(transaction, builder);
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
        final builder = data.builder.withChangeIfNeeded();
        final txBody = builder.buildBody();

        final transaction = Transaction(
          body: txBody,
          isValid: true,
          witnessSet: TransactionBuilder.generateFakeWitnessSet(
            builder.inputs,
            builder.requiredSigners,
          ),
          auxiliaryData: builder.auxiliaryData,
        );

        verifyTransactionFee(transaction, builder);
      },
    );
  });
}
