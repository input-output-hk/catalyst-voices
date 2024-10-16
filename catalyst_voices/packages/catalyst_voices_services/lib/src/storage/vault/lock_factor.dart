import 'dart:convert';

import 'package:catalyst_voices_services/src/storage/vault/vault.dart';
import 'package:flutter/foundation.dart';

// Note.
// In future we may add MultiLockFactor for bio and password unlock factors

/// Abstract representation of different factors that can lock [Vault] with.
///
/// Most common is [PasswordLockFactor] which can be use as standalone factor.
abstract interface class LockFactor {
  Uint8List get seed;
}

/// Password matching [LockFactor].
///
/// Only unlocks other [PasswordLockFactor] with matching
/// [PasswordLockFactor._data].
final class PasswordLockFactor implements LockFactor {
  final String _data;

  const PasswordLockFactor(this._data);

  @override
  Uint8List get seed => utf8.encode(_data);

  @override
  String toString() => 'PasswordLockFactor(${_data.hashCode})';
}
