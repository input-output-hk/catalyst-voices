//ignore_for_file: avoid_positional_boolean_parameters

import 'dart:async';
import 'dart:convert';

import 'package:catalyst_voices_shared/src/storage/storage.dart';
import 'package:flutter/foundation.dart';

/// Utility mixin which implements all but String read/write of [Storage]
/// interface. Every method is has its mapping to [readString]/[writeString].
mixin StorageAsStringMixin implements Storage {
  @override
  FutureOr<int?> readInt({required String key}) async {
    final value = await readString(key: key);
    return value != null ? int.parse(value) : null;
  }

  @override
  FutureOr<void> writeInt(
    int? value, {
    required String key,
  }) {
    return writeString(value?.toString(), key: key);
  }

  @override
  FutureOr<bool?> readBool({required String key}) async {
    final value = await readInt(key: key);

    return switch (value) {
      0 => false,
      1 => true,
      _ => null,
    };
  }

  @override
  FutureOr<void> writeBool(
    bool? value, {
    required String key,
  }) {
    final asInt = value != null
        ? value
            ? 1
            : 0
        : null;

    return writeInt(asInt, key: key);
  }

  @override
  FutureOr<Uint8List?> readBytes({required String key}) async {
    final base64String = await readString(key: key);
    final bytes = base64String != null
        ? Uint8List.fromList(base64Decode(base64String))
        : null;

    return bytes;
  }

  @override
  FutureOr<void> writeBytes(
    Uint8List? value, {
    required String key,
  }) {
    final base64String = value != null ? base64Encode(value) : null;

    return writeString(base64String, key: key);
  }

  @override
  FutureOr<void> delete({required String key}) => writeString(null, key: key);
}
