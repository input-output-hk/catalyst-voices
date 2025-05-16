import 'package:catalyst_voices_models/src/user/account_role.dart';
import 'package:test/test.dart';

void main() {
  group(AccountRole, () {
    test('registrationOffset is hardcoded', () {
      expect(AccountRole.voter.registrationOffset, equals(0));
      expect(AccountRole.drep.registrationOffset, equals(1));
      expect(AccountRole.proposer.registrationOffset, equals(2));
    });

    test('registrationOffset is not duplicated', () {
      final offsets = AccountRole.values.map((e) => e.registrationOffset).toList();
      final uniqueOffsets = offsets.toSet().toList();

      expect(offsets, hasLength(uniqueOffsets.length));
    });
  });
}
