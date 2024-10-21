import 'dart:convert';
import 'dart:typed_data';

/// Abstract representation of different factors that can lock secure data.
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
