import 'dart:async';
import 'dart:convert';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

const _requiredTapCount = 6;
final _logger = Logger('DevToolsBloc');

final class DevToolsBloc extends Bloc<DevToolsEvent, DevToolsState>
    with BlocSignalEmitterMixin<DevToolsSignal, DevToolsState> {
  final DevToolsService _devToolsService;
  final LoggingService? _loggingService;
  final DownloaderService _downloaderService;

  Timer? _resetCountTimer;

  DevToolsBloc(
    this._devToolsService,
    this._loggingService,
    this._downloaderService,
  ) : super(const DevToolsState()) {
    on<DevToolsEnablerTappedEvent>(_handleEnablerTap);
    on<DevToolsEnablerTapResetEvent>(_handleTapCountReset);
    on<RecoverConfigEvent>(_handleRecoverConfig);
    on<UpdateSystemInfoEvent>(_handleUpdateSystemInfo);
    on<ChangeLogLevelEvent>(_handleChangeLogLevel);
    on<ChangeCollectLogsEvent>(_handleChangeCollectLogs);
    on<PrepareAndExportLogsEvent>(_handleExportLogs);

    add(const RecoverConfigEvent());
  }

  @override
  Future<void> close() {
    _resetCountTimer?.cancel();
    _resetCountTimer = null;

    return super.close();
  }

  Future<void> _handleChangeCollectLogs(
    ChangeCollectLogsEvent event,
    Emitter<DevToolsState> emit,
  ) async {
    assert(_loggingService != null, 'Changing collect logs while LoggingService not available');

    final collectLogs = event.isEnabled;

    final settings = await _loggingService!.updateSettings(collectLogs: Optional(collectLogs));

    if (!isClosed) emit(state.copyWith(collectLogs: settings.effectiveCollectLogs));
  }

  Future<void> _handleChangeLogLevel(
    ChangeLogLevelEvent event,
    Emitter<DevToolsState> emit,
  ) async {
    assert(_loggingService != null, 'Changing log level while LoggingService not available');

    final level = event.level;

    final settings = await _loggingService!.updateSettings(level: Optional(level));

    if (!isClosed) emit(state.copyWith(logsLevel: Optional(settings.effectiveLevel)));
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

  Future<void> _handleExportLogs(
    PrepareAndExportLogsEvent event,
    Emitter<DevToolsState> emit,
  ) async {
    assert(_loggingService != null, 'Exporting logs while LoggingService not available');

    try {
      final content = await _loggingService!.prepareForExportCollectedLogs();
      final encodedContent = utf8.encode(content);

      final filename = 'catalyst_app_${DateTimeExt.now().toIso8601String()}_logs.txt';

      await _downloaderService.download(data: encodedContent, filename: filename);
    } catch (error, stack) {
      _logger.severe('Exporting logs failed', error, stack);
    }
  }

  Future<void> _handleRecoverConfig(
    RecoverConfigEvent event,
    Emitter<DevToolsState> emit,
  ) async {
    final isDeveloper = await _devToolsService.isDeveloper();
    final areLogsOptionsAvailable = _loggingService != null;
    final loggingSettings = await _loggingService?.getSettings();

    if (!isClosed) {
      emit(
        state.copyWith(
          isDeveloper: isDeveloper,
          areLogsOptionsAvailable: areLogsOptionsAvailable,
          logsLevel: Optional(loggingSettings?.effectiveLevel),
          collectLogs: loggingSettings?.effectiveCollectLogs ?? false,
        ),
      );
    }
  }

  void _handleTapCountReset(
    DevToolsEnablerTapResetEvent event,
    Emitter<DevToolsState> emit,
  ) {
    _resetCountTimer?.cancel();
    _resetCountTimer = null;

    emit(state.copyWith(enableTapCount: 0));
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
}
