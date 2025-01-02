import 'dart:async';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_shared/src/storage/storage_string_mixin.dart';

base class MemoryStorage with StorageAsStringMixin implements Storage {
  final _data = <String, String>{};

  MemoryStorage();

  @override
  Future<bool> contains({required String key}) async {
    return _data.containsKey(key);
  }

  @override
  FutureOr<String?> readString({required String key}) {
    return _data[key];
  }

  @override
  FutureOr<void> writeString(
    String? value, {
    required String key,
  }) {
    if (value != null) {
      _data[key] = value;
    } else {
      _data.remove(key);
    }
  }

  @override
  FutureOr<void> clear() {
    _data.clear();
  }
}
