import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';

/// A Cubit that monitors the global synchronization status.
///
/// Emits [SyncIndicatorState] with [SyncIndicatorState.isSyncing] set to `true`
/// when documents are being synchronized.
final class SyncIndicatorCubit extends Cubit<SyncIndicatorState> {
  final SyncManager _syncManager;
  StreamSubscription<double>? _progressSub;

  SyncIndicatorCubit(this._syncManager) : super(const SyncIndicatorState());

  @override
  Future<void> close() async {
    await _progressSub?.cancel();
    _progressSub = null;
    return super.close();
  }

  /// Starts monitoring the sync status.
  void init() {
    _progressSub = _syncManager.activeRequestProgress.listen(_onProgress);
  }

  void _onProgress(double progress) {
    if (!state.isSyncing) {
      emit(state.copyWith(isSyncing: true));
    }

    if (progress >= 1.0 && state.isSyncing) {
      emit(state.copyWith(isSyncing: false));
    }
  }
}
