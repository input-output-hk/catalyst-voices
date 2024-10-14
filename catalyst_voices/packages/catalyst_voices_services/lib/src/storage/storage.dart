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
  /// Returns true if a [String] with given [key] exists
  /// in the storage and has non-null value.
  ///
  /// The method must be always callable,
  /// despite the session being locked, keychain encrypted, etc.
  Future<bool> containsString({required String key});

  /// Returns the [String] by [key] or null if not set.
  FutureOr<String?> readString({required String key});

  /// Write the [value] to a [key]. Set [value] to null to clear it.
  FutureOr<void> writeString(
    String? value, {
    required String key,
  });

  /// Returns true if a [int] with given [key] exists
  /// in the storage and has non-null value.
  ///
  /// The method must be always callable,
  /// despite the session being locked, keychain encrypted, etc.
  Future<bool> containsInt({required String key});

  /// Returns the [int] by [key] or null if not set.
  FutureOr<int?> readInt({required String key});

  /// Write the [value] to a [key]. Set [value] to null to clear it.
  FutureOr<void> writeInt(
    int? value, {
    required String key,
  });

  /// Returns true if a [bool] with given [key] exists
  /// in the storage and has non-null value.
  ///
  /// The method must be always callable,
  /// despite the session being locked, keychain encrypted, etc.
  Future<bool> containsBool({required String key});

  /// Returns the [bool] by [key] or null if not set.
  FutureOr<bool?> readBool({required String key});

  /// Write the [value] to a [key]. Set [value] to null to clear it.
  FutureOr<void> writeBool(
    bool? value, {
    required String key,
  });

  /// Returns true if [Uint8List] with given [key] exists
  /// in the storage and has non-null value.
  ///
  /// The method must be always callable,
  /// despite the session being locked, keychain encrypted, etc.
  Future<bool> containsBytes({required String key});

  /// Returns the [Uint8List] by [key] or null if not set.
  FutureOr<Uint8List?> readBytes({required String key});

  /// Write the [value] to a [key]. Set [value] to null to clear it.
  FutureOr<void> writeBytes(
    Uint8List? value, {
    required String key,
  });

  /// Clears the [key].
  FutureOr<void> delete({required String key});

  /// Clears all the keys in the storage.
  FutureOr<void> clear();
}
