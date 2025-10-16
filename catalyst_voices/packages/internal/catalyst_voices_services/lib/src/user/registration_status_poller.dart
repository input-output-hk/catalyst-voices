import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

final _logger = Logger('RegistrationStatusPoller');

typedef CatalystIdRegStatus = ({CatalystId catalystId, AccountRegistrationStatus status});

abstract interface class RegistrationStatusPoller {
  factory RegistrationStatusPoller(UserRepository userRepository) = _RegistrationStatusPollerImpl;

  Future<void> dispose();

  Stream<CatalystIdRegStatus> start(CatalystId catalystId);

  void stop();
}

final class _RegistrationStatusPollerImpl implements RegistrationStatusPoller {
  final UserRepository _userRepository;
  final _statusStreamController = StreamController<CatalystIdRegStatus>();

  Timer? _pullStatusTimer;
  CatalystId? _catalystId;

  _RegistrationStatusPollerImpl(
    this._userRepository,
  ) {
    _statusStreamController
      ..onListen = _schedulePull
      ..onPause = _cancelPulling
      ..onResume = _schedulePull
      ..onCancel = stop;
  }

  @override
  Future<void> dispose() async {
    _logger.finest('Disposing');

    stop();

    await _statusStreamController.close();
  }

  @override
  Stream<CatalystIdRegStatus> start(CatalystId catalystId) {
    _logger.finest('Starting for $catalystId');

    assert(_catalystId == null, 'Stop pulling before starting new one');
    _catalystId = catalystId;
    return _statusStreamController.stream;
  }

  @override
  void stop() {
    _logger.finest('Stopping');

    _cancelPulling();

    _catalystId = null;
  }

  void _cancelPulling() {
    _logger.finest('Cancelling');

    _pullStatusTimer?.cancel();
    _pullStatusTimer = null;
  }

  Future<void> _pullRegistrationStatus() async {
    final catalystId = _catalystId;
    assert(catalystId != null, 'Tried pulling registration status but catalystId was empty');
    catalystId!;

    try {
      final registration = await _userRepository.getRbacRegistration(catalystId: catalystId);

      final isPersistent = registration.lastPersistentTxn != null;
      final status = AccountRegistrationStatus.indexed(isPersistent: isPersistent);
      final event = (catalystId: catalystId, status: status);

      _logger.finest('Pulled account($catalystId) registration status -> $status');

      _statusStreamController.add(event);
    } on UnauthorizedException catch (_) {
      const status = AccountRegistrationStatus.notIndexed();
      final event = (catalystId: catalystId, status: status);

      _logger.finest('Pulled account($catalystId) failed with unauthorized. Not indexed.');

      _statusStreamController.add(event);
    } on NotFoundException catch (_) {
      const status = AccountRegistrationStatus.notIndexed();
      final event = (catalystId: catalystId, status: status);

      _logger.finest('Pulled account($catalystId) failed with not found. Not indexed.');

      _statusStreamController.add(event);
    } catch (error) {
      _logger.finest('Pulled account($catalystId) failed with ${error.runtimeType}.');

      //no-op
    }
  }

  void _schedulePull() {
    _logger.finest('Scheduling');

    _pullStatusTimer = Timer.periodic(
      const Duration(minutes: 1),
      (timer) {
        unawaited(_pullRegistrationStatus());
      },
    );
  }
}
