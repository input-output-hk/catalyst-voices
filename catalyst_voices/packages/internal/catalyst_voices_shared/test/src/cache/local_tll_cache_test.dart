import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  late final SharedPreferencesAsync sharedPreferences;

  final now = DateTime(2024, 12, 10, 12, 34);

  setUpAll(() {
    final store = InMemorySharedPreferencesAsync.empty();
    SharedPreferencesAsyncPlatform.instance = store;
    sharedPreferences = SharedPreferencesAsync();
  });

  setUp(() {
    DateTimeExt.mockedDateTime = now;
  });

  tearDown(() async {
    await sharedPreferences.clear();
  });

  group(LocalTllCache, () {
    test('when key is not expired value is returned', () async {
      // Given
      final cache = LocalTllCache(sharedPreferences: sharedPreferences);
      const key = 'isUnlocked';
      const value = true;

      // When
      await cache.set('$value', key: key);

      // Then
      final cachedValue = await cache.get(key: key);

      expect(cachedValue, '$value');
    });

    test('when key is expired null is returned', () async {
      // Given
      final cache = LocalTllCache(sharedPreferences: sharedPreferences);
      const key = 'isUnlocked';
      const value = true;
      const ttl = Duration(hours: 1);

      // When
      await cache.set('$value', key: key, ttl: ttl);

      DateTimeExt.mockedDateTime = now.add(ttl);

      // Then
      final cachedValue = await cache.get(key: key);

      expect(cachedValue, isNull);
    });

    test('extend expiration makes key valid for longer', () async {
      // Given
      final cache = LocalTllCache(sharedPreferences: sharedPreferences);
      const key = 'isUnlocked';
      const value = true;
      const ttl = Duration(hours: 1);

      // When
      await cache.set('$value', key: key);
      await cache.extendExpiration(key: key, ttl: ttl);

      DateTimeExt.mockedDateTime = now.add(ttl - const Duration(seconds: 1));

      // Then
      final cachedValue = await cache.get(key: key);

      expect(cachedValue, '$value');
    });
  });
}
