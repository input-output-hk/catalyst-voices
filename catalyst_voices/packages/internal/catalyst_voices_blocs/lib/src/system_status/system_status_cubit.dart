import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';

final class SystemStatusCubit extends Cubit<SystemStatusState>
    with BlocErrorEmitterMixin, BlocSignalEmitterMixin<SystemStatusSignal, SystemStatusState> {
  final SystemStatusService _systemStatusService;

  final _logger = Logger('SystemStatusCubit');

  StreamSubscription<List<ComponentStatus>>? _systemComponentStatusesSub;

  SystemStatusCubit(
    this._systemStatusService,
  ) : super(const SystemStatusState()) {
    _systemComponentStatusesSub = _systemStatusService
        .pollComponentStatuses()
        .distinct(const DeepCollectionEquality.unordered().equals)
        .listen(
          _onSystemComponentStatusesChanged,
          onError: _onSystemComponentStatusesError,
        );
  }

  Future<void> checkAppVersion() async {
    try {
      final isUpdateAvailable = await _systemStatusService.isUpdateAvailable();
      if (isUpdateAvailable) {
        emitSignal(const NewVersionAvailable());
      }
    } catch (e, st) {
      _logger.warning("Couldn't retrieve app version info", e, st);
    }
  }

  @override
  Future<void> close() async {
    await _systemComponentStatusesSub?.cancel();
    _systemComponentStatusesSub = null;

    return super.close();
  }

  void _onSystemComponentStatusesChanged(List<ComponentStatus> statuses) {
    if (statuses.any((e) => !e.isOperational)) {
      _logger.fine('At least one component is not operational: $statuses');
      emitSignal(const SystemStatusIssueSignal());
    } else {
      _logger.fine('All components are operational: $statuses');
      emitSignal(const CancelSystemStatusIssueSignal());
    }
  }

  void _onSystemComponentStatusesError(Object error, StackTrace stackTrace) {
    _logger.severe('Error fetching system component statuses', error, stackTrace);
  }
}
