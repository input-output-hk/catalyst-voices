import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/api/models/catalyst_id_public.dart';
import 'package:catalyst_voices_repositories/src/dto/user/catalyst_id_public_ext.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CatalystIdPublicExt', () {
    group('toModel', () {
      test('full json is decoded correctly', () {
        // Given
        final json = <String, dynamic>{
          'email': 'dev@iohk.io',
          'username': 'dev',
          'status': 1,
          'rbac_reg_status': 3,
        };
        const expectedProfile = AccountPublicProfile(
          email: 'dev@iohk.io',
          username: 'dev',
          status: AccountPublicStatus.verified,
          rbacRegStatus: AccountPublicRbacStatus.persistent,
        );

        // When
        final publicCatId = CatalystIdPublic.fromJson(json);
        final publicProfile = publicCatId.toModel();

        // Then
        expect(publicProfile, expectedProfile);
      });

      /* cSpell:disable */
      group('username', () {
        test('spaces are handled correctly', () {
          // Given
          const sourceUsername = 'First%20Last';
          const expectedUsername = 'First Last';
          const id = CatalystIdPublic(username: sourceUsername);

          // When
          final model = id.toModel();

          // Then
          expect(model.username, expectedUsername);
        });

        test('diacritical characters are handled correctly', () {
          // Given
          const sourceUsername = 'First Ląst';
          const expectedUsername = 'First Ląst';
          const id = CatalystIdPublic(username: sourceUsername);

          // When
          final model = id.toModel();

          // Then
          expect(model.username, expectedUsername);
        });

        test('diacritical characters with while spaces are handled correctly', () {
          // Given
          const sourceUsername = 'First%20Ląst';
          const expectedUsername = 'First Ląst';
          const id = CatalystIdPublic(username: sourceUsername);

          // When
          final model = id.toModel();

          // Then
          expect(model.username, expectedUsername);
        });
      });
      /* cSpell:enable */
    });
  });
}
