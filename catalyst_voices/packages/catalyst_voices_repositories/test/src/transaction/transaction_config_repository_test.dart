import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:test/test.dart';

void main() {
  group(TransactionConfigRepository, () {
    late TransactionConfigRepository repository;

    setUp(() {
      repository = TransactionConfigRepository();
    });

    test('fetchConfig for all networks returns non empty fee', () async {
      for (final networkId in NetworkId.values) {
        final config = await repository.fetch(networkId);
        expect(config.feeAlgo.constant, isNonZero);
        expect(config.feeAlgo.coefficient, isNonZero);
      }
    });
  });
}
