import 'package:catalyst_voices_services/src/user/dummy_user_service.dart';
import 'package:test/test.dart';

void main() {
  group(DummyUserFactory, () {
    late DummyUserFactory factory;

    setUp(() {
      factory = DummyUserFactory();
    });

    test('dummy user returns account with dummy keychain', () {
      expect(
        factory.buildDummyUser().accounts.single.keychainId,
        equals(DummyUserFactory.dummyKeychainId),
      );
    });

    test('dummy account returns account with dummy keychain', () {
      expect(
        factory.buildDummyAccount().keychainId,
        equals(DummyUserFactory.dummyKeychainId),
      );
    });
  });
}
