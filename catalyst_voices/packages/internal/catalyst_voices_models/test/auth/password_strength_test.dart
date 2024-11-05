import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:test/test.dart';

void main() {
  group(PasswordStrength, () {
    test('weak password - too short', () {
      expect(
        PasswordStrength.calculate('123456'),
        equals(PasswordStrength.weak),
      );

      expect(
        PasswordStrength.calculate('Ab1!@_'),
        equals(PasswordStrength.weak),
      );
    });

    test('weak password - too popular', () {
      expect(
        PasswordStrength.calculate('password'),
        equals(PasswordStrength.weak),
      );
    });

    test('weak password - too simple', () {
      expect(
        /* cSpell:disable */
        PasswordStrength.calculate('simplepw'),
        /* cSpell:enable */
        equals(PasswordStrength.weak),
      );
    });

    test('normal password', () {
      expect(
        PasswordStrength.calculate('Passwd12'),
        equals(PasswordStrength.normal),
      );
    });

    test('strong password', () {
      expect(
        PasswordStrength.calculate('Passwd!@'),
        equals(PasswordStrength.strong),
      );
    });

    test('strong password', () {
      expect(
        PasswordStrength.calculate('4Gf;Rd04WP,RxgBl)n5&RlG'),
        equals(PasswordStrength.strong),
      );
    });
  });
}
