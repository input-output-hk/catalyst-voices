//ignore_for_file: one_member_abstracts

/// May want to add bio unlock so need more "factors"
///
/// In future we may add MultiLockFactor for bio and password unlock factors
abstract interface class LockFactor {
  bool unlocks(LockFactor factor);
}

final class VoidLockFactor implements LockFactor {
  const VoidLockFactor();

  @override
  bool unlocks(LockFactor factor) => false;

  @override
  String toString() => 'VoidLockFactor';
}

final class PasswordLockFactor implements LockFactor {
  final String data;

  const PasswordLockFactor(this.data);

  @override
  bool unlocks(LockFactor factor) {
    return factor is PasswordLockFactor && data == factor.data;
  }

  @override
  String toString() => 'PasswordLockFactor data=****';
}
