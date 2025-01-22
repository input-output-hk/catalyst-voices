import 'package:catalyst_voices_repositories/src/dto/user_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(AccountDto, () {
    group('migration', () {
      group('base profile', () {
        test('adds missing properties when missing', () {
          // Given
          /* cSpell:disable */
          const json = <String, dynamic>{
            'keychainId': 'uuid',
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
      });
    });
  });
}
