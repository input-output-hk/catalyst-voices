import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/user/user_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(AccountDto, () {
    group('migration', () {
      group('email', () {
        test('parses from json normally', () {
          // Given
          const email = 'dev@iohk';
          /* cSpell:disable */
          final json = <String, dynamic>{
            'catalystId': 'cardano/uuid',
            'keychainId': 'uuid',
            'email': email,
            'roles': ['voter'],
            'walletInfo': {
              'metadata': {
                'name': 'Eternl',
              },
              'balance': 0,
              'address': 'addr_test1vzpwq95z3xyum8vqn'
                  'dgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw',
            },
            'isProvisional': true,
          };
          /* cSpell:enable */

          // When
          AccountDto parse() => AccountDto.fromJson(json);

          // Then
          expect(parse, returnsNormally);
        });

        test('migrates email correctly', () {
          // Given
          const email = 'dev@iohk';
          /* cSpell:disable */
          final json = <String, dynamic>{
            'catalystId': 'cardano/uuid',
            'keychainId': 'uuid',
            'email': email,
            'roles': ['voter'],
            'address': 'addr_test1vzpwq95z3xyum8vqn'
                'dgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw',
            'isProvisional': true,
          };
          /* cSpell:enable */

          // When
          final dto = AccountDto.fromJson(json);

          // Then
          expect(dto.email, isNotNull);
          expect(dto.email, email);
          expect(dto.publicStatus, isNull);
        });

        test('correct email model is not affected', () {
          // Given
          const email = 'dev@iohk';
          const status = AccountPublicStatus.verified;

          /* cSpell:disable */
          final json = <String, dynamic>{
            'catalystId': 'cardano/uuid',
            'keychainId': 'uuid',
            'email': email,
            'roles': ['voter'],
            'address': 'addr_test1vzpwq95z3xyum8vqn'
                'dgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw',
            'isProvisional': true,
            'publicStatus': status.name,
          };
          /* cSpell:enable */

          // When
          final dto = AccountDto.fromJson(json);

          // Then
          expect(dto.email, isNotNull);
          expect(dto.email, email);
          expect(dto.publicStatus, status);
        });
      });
    });
  });
}
