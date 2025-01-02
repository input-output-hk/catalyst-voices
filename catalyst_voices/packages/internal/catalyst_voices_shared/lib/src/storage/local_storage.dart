import 'dart:async';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_shared/src/storage/storage_string_mixin.dart';
import 'package:shared_preferences/shared_preferences.dart';

base class LocalStorage with StorageAsStringMixin implements Storage {
  final String key;

  /// See [SharedPreferencesAsync.clear].
  final Set<String>? allowList;
  final SharedPreferencesAsync _sharedPreferences;

  LocalStorage({
    this.key = 'LocalStorage',
    this.allowList,
    required SharedPreferencesAsync sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  @override
  Future<bool> contains({required String key}) {
    final effectiveKey = _effectiveKey(key);

    return _sharedPreferences.containsKey(effectiveKey);
  }

  @override
  Future<String?> readString({required String key}) {
    final effectiveKey = _effectiveKey(key);

    return _sharedPreferences.getString(effectiveKey);
  }

  @override
  Future<void> writeString(
    String? value, {
    required String key,
  }) async {
    final effectiveKey = _effectiveKey(key);

    if (value != null) {
      await _sharedPreferences.setString(effectiveKey, value);
    } else {
      await _sharedPreferences.remove(effectiveKey);
    }
  }

  @override
  Future<void> clear() async {
    final keysToRemove = allowList?.map(_effectiveKey).toSet() ??
        await () async {
          final keys = await _sharedPreferences.getKeys();
          return keys.where((element) => element.startsWith(key)).toSet();
        }();

    await _sharedPreferences.clear(allowList: keysToRemove);
  }

  String _effectiveKey(String value) {
    return '$key.$value';
  }
}
