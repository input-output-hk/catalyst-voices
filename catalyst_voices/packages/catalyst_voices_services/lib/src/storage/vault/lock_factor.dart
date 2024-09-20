enum _LockFactorType { voidFactor, password }

/// May want to add bio unlock so need more "factors"
///
/// In future we may add MultiLockFactor for bio and password unlock factors
sealed class LockFactor {
  factory LockFactor.fromJson(Map<String, dynamic> json) {
    final typeName = json['type'];
    final type = _LockFactorType.values.asNameMap()[typeName];

    return switch (type) {
      _LockFactorType.voidFactor => const VoidLockFactor(),
      _LockFactorType.password => PasswordLockFactor.fromJson(json),
      null => throw ArgumentError('Unknown type name($typeName)', 'json'),
    };
  }

  bool unlocks(LockFactor factor);

  Map<String, dynamic> toJson();
}

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

final class PasswordLockFactor implements LockFactor {
  final String data;

  const PasswordLockFactor(this.data);

  factory PasswordLockFactor.fromJson(Map<String, dynamic> json) {
    return PasswordLockFactor(
      json['data'] as String,
    );
  }

  @override
  bool unlocks(LockFactor factor) {
    return factor is PasswordLockFactor && data == factor.data;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': _LockFactorType.password.name,
      'data': data,
    };
  }

  @override
  String toString() => 'PasswordLockFactor(data=****)';
}
