import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';

const _kMinSyncingDuration = Duration(seconds: 2);

/// A Cubit that monitors the global synchronization status.
///
/// Emits [SyncIndicatorState] with [SyncIndicatorState.isSyncing] set to `true`
/// when documents are being synchronized.
///
/// The indicator will be shown for at least [_kMinSyncingDuration] to avoid
/// flickering when sync completes quickly.
final class SyncIndicatorCubit extends Cubit<SyncIndicatorState> {
  final SyncManager _syncManager;
  StreamSubscription<double>? _progressSub;
  DateTime? _syncingStartTime;
  Timer? _syncingTimer;

  SyncIndicatorCubit(this._syncManager) : super(const SyncIndicatorState());

  @override
  Future<void> close() async {
    await _progressSub?.cancel();
    _progressSub = null;
    _syncingTimer?.cancel();
    _syncingTimer = null;
    _syncingStartTime = null;
    return super.close();
  }

  /// Starts monitoring the sync status.
  void init() {
    _progressSub = _syncManager.activeRequestProgress.listen(_onProgress);
  }

  void _onProgress(double progress) {
    final isSyncing = progress > 0.0 && progress < 1.0;

    if (isSyncing && !state.isSyncing) {
      _syncingTimer?.cancel();
      _syncingStartTime = DateTime.now();
      emit(state.copyWith(isSyncing: true));
    } else if (!isSyncing && state.isSyncing) {
      final elapsed = DateTime.now().difference(_syncingStartTime!);
      final remaining = _kMinSyncingDuration - elapsed;

      if (remaining.isNegative) {
        emit(state.copyWith(isSyncing: false));
      } else {
        _syncingTimer?.cancel();
        _syncingTimer = Timer(remaining, () {
          emit(state.copyWith(isSyncing: false));
        });
      }
    }
  }
}
