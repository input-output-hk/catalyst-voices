import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';

final class SystemStatusCubit extends Cubit<SystemStatusState>
    with BlocErrorEmitterMixin, BlocSignalEmitterMixin<SystemStatusSignal, SystemStatusState> {
  final SystemStatusRepository _systemStatusRepository;

  final _logger = Logger('SystemStatusCubit');

  StreamSubscription<List<ComponentStatus>>? _systemComponentStatusesSub;

  SystemStatusCubit(
    this._systemStatusRepository,
  ) : super(const SystemStatusState()) {
    _systemComponentStatusesSub = _systemStatusRepository
        .pollComponentStatuses()
        .distinct(const DeepCollectionEquality.unordered().equals)
        .listen(
          _onSystemComponentStatusesChanged,
          onError: _onSystemComponentStatusesError,
        );
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
