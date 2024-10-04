import 'package:catalyst_voices_services/src/storage/vault/vault.dart';

enum _LockFactorType { voidFactor, password }

// Note.
// In future we may add MultiLockFactor for bio and password unlock factors

/// Abstract representation of different factors that can lock [Vault] with.
///
/// Most common is [PasswordLockFactor] which can be use as standalone factor.
///
/// This class is serializable to/from json.
sealed class LockFactor {
  /// Use [LockFactor.toJson] as parameter for this factory.
  factory LockFactor.fromJson(Map<String, dynamic> json) {
    final typeName = json['type'];
    final type = _LockFactorType.values.asNameMap()[typeName];

    return switch (type) {
      _LockFactorType.voidFactor => const VoidLockFactor(),
      _LockFactorType.password => PasswordLockFactor.fromJson(json),
      null => throw ArgumentError('Unknown type name($typeName)', 'json'),
    };
  }

  /// Returns true when this [LockFactor] can be used to unlock
  /// other [LockFactor].
  bool unlocks(LockFactor factor);

  /// Returns json representation on this [LockFactor].
  ///
  /// Should be used with [LockFactor.fromJson].
  Map<String, dynamic> toJson();
}

/// Can not be used to unlock anything. Useful as default value for [LockFactor]
/// variables.
///
/// [unlocks] always returns false.
final class VoidLockFactor implements LockFactor {
  const VoidLockFactor();

  @override
  bool unlocks(LockFactor factor) => false;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': _LockFactorType.voidFactor.name,
    };
  }

  @override
  String toString() => 'VoidLockFactor';
}

/// Password matching [LockFactor].
///
/// Only unlocks other [PasswordLockFactor] with matching
/// [PasswordLockFactor._data].
final class PasswordLockFactor implements LockFactor {
  final String _data;

  const PasswordLockFactor(this._data);

  factory PasswordLockFactor.fromJson(Map<String, dynamic> json) {
    return PasswordLockFactor(
      json['data'] as String,
    );
  }

  @override
  bool unlocks(LockFactor factor) {
    return factor is PasswordLockFactor && _data == factor._data;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': _LockFactorType.password.name,
      'data': _data,
    };
  }

  @override
  String toString() => 'PasswordLockFactor(${_data.hashCode})';
}
