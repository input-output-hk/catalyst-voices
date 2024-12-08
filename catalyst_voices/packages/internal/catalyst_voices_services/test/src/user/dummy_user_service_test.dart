import 'package:catalyst_voices_services/src/user/dummy_user_service.dart';
import 'package:test/test.dart';

void main() {
  group(DummyUserService, () {
    late DummyUserService service;

    setUp(() {
      service = DummyUserService();
    });

    test('dummy user returns account with dummy keychain', () {
      expect(
        service.getDummyUser().accounts.single.keychainId,
        equals(DummyUserService.dummyKeychainId),
      );
    });

    test('dummy account returns account with dummy keychain', () {
      expect(
        service.getDummyAccount().keychainId,
        equals(DummyUserService.dummyKeychainId),
      );
    });
  });
}
