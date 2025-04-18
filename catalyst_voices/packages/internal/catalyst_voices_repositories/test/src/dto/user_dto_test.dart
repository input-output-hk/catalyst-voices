import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/user_dto.dart';
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
          final dto = AccountDto.fromJson(json);

          // Then
          expect(dto.email, isNotNull);
          expect(dto.email!.email, email);
          expect(dto.email!.status, AccountEmailVerificationStatus.unknown);
        });

        test('correct email model is not affected', () {
          // Given
          const email = 'dev@iohk';
          const status = AccountEmailVerificationStatus.verified;

          /* cSpell:disable */
          final json = <String, dynamic>{
            'catalystId': 'cardano/uuid',
            'keychainId': 'uuid',
            'email': {
              'email': email,
              'status': status.name,
            },
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
          final dto = AccountDto.fromJson(json);

          // Then
          expect(dto.email, isNotNull);
          expect(dto.email!.email, email);
          expect(dto.email!.status, status);
        });
      });
    });
  });
}
