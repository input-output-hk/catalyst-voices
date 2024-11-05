import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:test/test.dart';

void main() {
  group(TransactionWitnessSetBuilder, () {
    final witness = VkeyWitness.seeded(1);

    test('add vkey', () {
      const builder = TransactionWitnessSetBuilder(vkeys: {}, vkeysCount: 1);
      final witnessSet = builder.addVkey(witness).build();
      expect(witnessSet.vkeyWitnesses.length, equals(1));
      expect(witnessSet.vkeyWitnesses.first, equals(witness));
    });

    test('remove vkey', () {
      final builder = TransactionWitnessSetBuilder(
        vkeys: {witness.vkey: witness},
        vkeysCount: 1,
      );
      final updatedBuilder = builder.removeVkey(witness.vkey);
      expect(updatedBuilder.vkeys, isEmpty);
    });

    test('build not matching expected vkeys count throws exception', () {
      const builder = TransactionWitnessSetBuilder(vkeys: {}, vkeysCount: 1);
      expect(
        builder.build,
        throwsA(const InvalidTransactionWitnessesException()),
      );
    });

    test('build fake will provide seeded witnesses', () {
      const builder = TransactionWitnessSetBuilder(vkeys: {}, vkeysCount: 2);
      final witnessSet = builder.buildFake();
      expect(
        witnessSet.vkeyWitnesses.length,
        equals(builder.vkeysCount),
      );
    });
  });
}
