import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:test/test.dart';

void main() {
  group(TransactionWitnessSetBuilder, () {
    final witness = VkeyWitness.seeded(1);

    test('add vkey', () {
      const builder = TransactionWitnessSetBuilder(vkeys: {});
      final witnessSet = builder.addVkey(witness).build();
      expect(witnessSet.vkeyWitnesses.length, equals(1));
      expect(witnessSet.vkeyWitnesses.first, equals(witness));
    });

    test('remove vkey', () {
      final builder = TransactionWitnessSetBuilder(
        vkeys: {witness.vkey: witness},
      );
      final updatedBuilder = builder.removeVkey(witness.vkey);
      expect(updatedBuilder.vkeys, isEmpty);
    });
  });
}
