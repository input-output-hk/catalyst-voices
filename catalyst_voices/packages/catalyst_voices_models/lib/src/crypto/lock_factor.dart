import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';

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
@immutable
final class PasswordLockFactor implements LockFactor {
  final String _data;

  const PasswordLockFactor(this._data);

  @override
  Uint8List get seed => utf8.encode(_data);

  @override
  String toString() => 'PasswordLockFactor(${_data.hashCode})';

  // Note. normal equals hash implementation because don't want to expose
  // password data.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PasswordLockFactor &&
          runtimeType == other.runtimeType &&
          _data == other._data;

  @override
  int get hashCode => _data.hashCode;
}
