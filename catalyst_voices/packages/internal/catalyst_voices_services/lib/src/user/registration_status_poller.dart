import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:flutter/foundation.dart';

abstract interface class RegistrationStatusPoller {
  factory RegistrationStatusPoller(UserRepository userRepository) = _RegistrationStatusPollerImpl;

  void start(
    Account account, {
    required ValueChanged<AccountRegistrationStatus> onChanged,
  });

  void stop();
}

final class _RegistrationStatusPollerImpl implements RegistrationStatusPoller {
  final UserRepository _userRepository;

  Timer? _pullStatusTimer;

  _RegistrationStatusPollerImpl(
    this._userRepository,
  );

  @override
  void start(
    Account account, {
    required ValueChanged<AccountRegistrationStatus> onChanged,
  }) {
    stop();

    _pullStatusTimer = Timer.periodic(
      const Duration(minutes: 1),
      (timer) {
        unawaited(_pullRegistrationStatus(account: account, onChanged: onChanged));
      },
    );
  }

  @override
  void stop() {
    _pullStatusTimer?.cancel();
    _pullStatusTimer = null;
  }

  Future<void> _pullRegistrationStatus({
    required Account account,
    required ValueChanged<AccountRegistrationStatus> onChanged,
  }) async {
    if (!await account.keychain.isUnlocked) {
      return;
    }

    final catalystId = account.catalystId;
    try {
      final registration = await _userRepository.getRbacRegistration(catalystId: catalystId);

      final isPersistent = registration.lastPersistentTxn != null;
      final status = AccountRegistrationStatus.indexed(isPersistent: isPersistent);

      onChanged(status);
    } on UnauthorizedException catch (_) {
      const status = AccountRegistrationStatus.notIndexed();
      onChanged(status);
    } on NotFoundException catch (_) {
      const status = AccountRegistrationStatus.notIndexed();
      onChanged(status);
    } catch (_) {
      //no-op
    }
  }
}
