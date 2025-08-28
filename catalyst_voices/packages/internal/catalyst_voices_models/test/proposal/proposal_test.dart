import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(Proposal, () {
    test('correct version number is returned even when version list is not sorted', () {
      final listOfVersions = [
        '019879f2-42ac-7000-8000-000000000000', //2025, 7, 25
        '01991997-66ac-7000-8000-000000000000', //2025, 8, 25
        '0199b416-2eac-7000-8000-000000000000', //2025, 9, 25
      ];

      final versionNumber = listOfVersions.versionNumber('0199b416-2eac-7000-8000-000000000000');

      expect(versionNumber, 3);
    });
  });
}
