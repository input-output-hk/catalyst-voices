import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

const _requiredTapCount = 6;
final _logger = Logger('DevToolsBloc');

final class DevToolsBloc extends Bloc<DevToolsEvent, DevToolsState>
    with BlocSignalEmitterMixin<DevToolsSignal, DevToolsState> {
  final DevToolsService _devToolsService;
  final SyncManager _syncManager;

  Timer? _resetCountTimer;
  StreamSubscription<SyncStats>? _syncStartsSub;

  DevToolsBloc(
    this._devToolsService,
    this._syncManager,
  ) : super(const DevToolsState()) {
    on<DevToolsEnablerTappedEvent>(_handleEnablerTap);
    on<DevToolsEnablerTapResetEvent>(_handleTapCountReset);
    on<RecoverDataEvent>(_handleRecoverData);
    on<UpdateSystemInfoEvent>(_handleUpdateSystemInfo);
    on<SyncDocumentsEvent>(_handleSyncDocuments);
    on<UpdateAllEvent>(_handleUpdateAll);
    on<WatchSystemInfoEvent>(_handleWatchSystemInfoEvent);
    on<StopWatchingSystemInfoEvent>(_handleStopWatchingSystemInfoEvent);
    on<SyncStatsChangedEvent>(_handleSyncStatsChanged);

    add(const RecoverDataEvent());
  }

  @override
  Future<void> close() {
    _resetCountTimer?.cancel();
    _resetCountTimer = null;

    _syncStartsSub?.cancel();
    _syncStartsSub = null;

    return super.close();
  }

  Future<void> _handleEnablerTap(
    DevToolsEnablerTappedEvent event,
    Emitter<DevToolsState> emit,
  ) async {
    _resetCountTimer?.cancel();
    _resetCountTimer = null;

    if (state.isDeveloper) {
      emitSignal(const AlreadyEnabledSignal());
      return;
    }

    final count = state.enableTapCount + 1;
    final isDeveloper = count >= _requiredTapCount;

    if (isDeveloper) {
      await _devToolsService.updateDevTools(isEnabled: true);
      emit(state.copyWith(enableTapCount: count, isDeveloper: isDeveloper));
      emitSignal(const BecameDeveloperSignal());
      return;
    }

    if (count > 1) {
      emitSignal(TapsLeftSignal(count: _requiredTapCount - count));
    }

    emit(state.copyWith(enableTapCount: count));

    _resetCountTimer = Timer(
      const Duration(seconds: 1),
      () => add(const DevToolsEnablerTapResetEvent()),
    );
  }

  Future<void> _handleRecoverData(
    RecoverDataEvent event,
    Emitter<DevToolsState> emit,
  ) async {
    final isDeveloper = await _devToolsService.isDeveloper();
    final syncStats = await _devToolsService.getStats();

    if (!isClosed) {
      emit(state.copyWith(isDeveloper: isDeveloper, syncStats: Optional(syncStats)));
    }
  }

  Future<void> _handleStopWatchingSystemInfoEvent(
    StopWatchingSystemInfoEvent event,
    Emitter<DevToolsState> emit,
  ) async {
    await _syncStartsSub?.cancel();
    _syncStartsSub = null;
  }

  Future<void> _handleSyncDocuments(
    SyncDocumentsEvent event,
    Emitter<DevToolsState> emit,
  ) async {
    try {
      await _syncManager.start();
    } catch (error, stack) {
      _logger.warning('Sync failed', error, stack);
    }
  }

  void _handleSyncStatsChanged(
    SyncStatsChangedEvent event,
    Emitter<DevToolsState> emit,
  ) {
    emit(state.copyWith(syncStats: Optional(event.stats)));
  }

  void _handleTapCountReset(
    DevToolsEnablerTapResetEvent event,
    Emitter<DevToolsState> emit,
  ) {
    _resetCountTimer?.cancel();
    _resetCountTimer = null;

    emit(state.copyWith(enableTapCount: 0));
  }

  Future<void> _handleUpdateAll(
    UpdateAllEvent event,
    Emitter<DevToolsState> emit,
  ) async {
    try {
      final systemInfo = await _devToolsService.getSystemInfo();
      final syncStats = await _devToolsService.getStats();

      if (!isClosed) {
        emit(state.copyWith(systemInfo: Optional(systemInfo), syncStats: Optional(syncStats)));
      }
    } catch (error, stack) {
      _logger.warning('Updating all failed', error, stack);
    }
  }

  Future<void> _handleUpdateSystemInfo(
    UpdateSystemInfoEvent event,
    Emitter<DevToolsState> emit,
  ) async {
    SystemInfo? systemInfo;

    try {
      systemInfo = await _devToolsService.getSystemInfo();
    } catch (error, stack) {
      _logger.warning('Updating system info failed', error, stack);
      systemInfo = null;
    } finally {
      if (!isClosed) {
        emit(state.copyWith(systemInfo: Optional(systemInfo)));
      }
    }
  }

  Future<void> _handleWatchSystemInfoEvent(
    WatchSystemInfoEvent event,
    Emitter<DevToolsState> emit,
  ) async {
    _syncStartsSub =
        _devToolsService.watchStats().listen((event) => add(SyncStatsChangedEvent(event)));
  }
}
