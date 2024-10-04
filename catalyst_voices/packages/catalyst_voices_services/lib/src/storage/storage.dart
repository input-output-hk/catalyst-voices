//ignore_for_file: avoid_positional_boolean_parameters

import 'dart:async';

import 'package:flutter/foundation.dart';

/// Abstract representation of generic storage. This interface does
/// not determinate where data should be stored or how it should be stored.
/// Encrypted or not.
///
/// Implementation may use local memory / filesystem or shared preferences or
/// any other.
abstract interface class Storage {
  FutureOr<String?> readString({required String key});

  FutureOr<void> writeString(
    String? value, {
    required String key,
  });

  FutureOr<int?> readInt({required String key});

  FutureOr<void> writeInt(
    int? value, {
    required String key,
  });

  FutureOr<bool?> readBool({required String key});

  FutureOr<void> writeBool(
    bool? value, {
    required String key,
  });

  FutureOr<Uint8List?> readBytes({required String key});

  FutureOr<void> writeBytes(
    Uint8List? value, {
    required String key,
  });

  FutureOr<void> delete({required String key});

  FutureOr<void> clear();
}
