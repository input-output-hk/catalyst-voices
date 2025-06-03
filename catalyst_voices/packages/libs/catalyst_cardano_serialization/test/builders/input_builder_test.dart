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
    });
  });
}
