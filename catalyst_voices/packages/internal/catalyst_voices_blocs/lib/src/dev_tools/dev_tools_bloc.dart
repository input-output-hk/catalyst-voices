import 'dart:async';
import 'dart:convert';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

const _requiredTapCount = 6;
final _logger = Logger('DevToolsBloc');

/// Manages the dev tools.
///
/// It allows developers to obtain information about the system.
final class DevToolsBloc extends Bloc<DevToolsEvent, DevToolsState>
    with BlocSignalEmitterMixin<DevToolsSignal, DevToolsState> {
  final DevToolsService _devToolsService;
  final SyncManager _syncManager;
  final LoggingService? _loggingService;
  final DownloaderService _downloaderService;
  final DocumentsService _documentsService;
  final CampaignService _campaignService;

  Timer? _resetCountTimer;
  StreamSubscription<SyncStats>? _syncStartsSub;
  StreamSubscription<int>? _documentsCountSub;
  StreamSubscription<Campaign?>? _activeCampaignSub;

  DevToolsBloc(
    this._devToolsService,
    this._syncManager,
    this._loggingService,
    this._downloaderService,
    this._documentsService,
    this._campaignService,
  ) : super(const DevToolsState()) {
    on<DevToolsEnablerTappedEvent>(_handleEnablerTap);
    on<DevToolsEnablerTapResetEvent>(_handleTapCountReset);
    on<InitDataEvent>(_handleInitData);
    on<SyncDocumentsEvent>(_handleSyncDocuments);
    on<WatchSystemInfoEvent>(_handleWatchSystemInfo);
    on<StopWatchingSystemInfoEvent>(_handleStopWatchingSystemInfo);
    on<WatchDocumentsEvent>(_handleWatchDocuments);
    on<StopWatchingDocumentsEvent>(_handleStopWatchingDocuments);
    on<WatchActiveCampaignEvent>(_handleWatchActiveCampaign);
    on<StopWatchingActiveCampaignEvent>(_handleStopWatchingActiveCampaign);
    on<DocumentsCountChangedEvent>(_updateDocumentsCountChanged);
    on<SyncStatsChangedEvent>(_handleSyncStatsChanged);
    on<ChangeLogLevelEvent>(_handleChangeLogLevel);
    on<ChangeCollectLogsEvent>(_handleChangeCollectLogsEvent);
    on<ChangeActiveCampaignEvent>(_handleChangeActiveCampaign);
    on<PrepareAndExportLogsEvent>(_handleExportLogs);
    on<ClearDocumentsEvent>(_handleClearDocuments);
    on<ActiveCampaignChangedEvent>(_handleActiveCampaignChanged);
  }

  @override
  Future<void> close() async {
    _resetCountTimer?.cancel();
    _resetCountTimer = null;

    await _syncStartsSub?.cancel();
    _syncStartsSub = null;

    await _documentsCountSub?.cancel();
    _documentsCountSub = null;

    await _activeCampaignSub?.cancel();
    _activeCampaignSub = null;

    return super.close();
  }

  void _handleActiveCampaignChanged(ActiveCampaignChangedEvent event, Emitter<DevToolsState> emit) {
    emit(state.copyWithActiveCampaign(event.campaign));
  }

  Future<void> _handleChangeActiveCampaign(
    ChangeActiveCampaignEvent event,
    Emitter<DevToolsState> emit,
  ) async {
    final previousCampaign = state.campaign.activeCampaign;
    try {
      emit(state.copyWithActiveCampaign(event.campaign));
      await _campaignService.changeActiveCampaign(event.campaign);
    } catch (error, stackTrace) {
      _logger.severe('handleChangeActiveCampaign', error, stackTrace);
      emit(state.copyWithActiveCampaign(previousCampaign));
    }
  }

  Future<void> _handleChangeCollectLogsEvent(
    ChangeCollectLogsEvent event,
    Emitter<DevToolsState> emit,
  ) async {
    assert(_loggingService != null, 'Changing collect logs while LoggingService not available');

    final collectLogs = event.isEnabled;

    final settings = await _loggingService!.updateSettings(collectLogs: Optional(collectLogs));

    emit(state.copyWith(collectLogs: settings.effectiveCollectLogs));
  }

  Future<void> _handleChangeLogLevel(ChangeLogLevelEvent event, Emitter<DevToolsState> emit) async {
    assert(_loggingService != null, 'Changing log level while LoggingService not available');

    final level = event.level;

    final settings = await _loggingService!.updateSettings(level: Optional(level));

    emit(state.copyWith(logsLevel: Optional(settings.effectiveLevel)));
  }

  Future<void> _handleClearDocuments(ClearDocumentsEvent event, Emitter<DevToolsState> emit) async {
    try {
      final deleteRows = await _documentsService.clear();

      _logger.finer('Deleted $deleteRows rows');
    } catch (error, stack) {
      _logger.warning('Documents clear', error, stack);
    }
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
      const Duration(seconds: 2),
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

      final filename = 'catalyst_app_${DateTimeExt.now().microsecondsSinceEpoch}_logs.txt';

      await _downloaderService.download(data: encodedContent, filename: filename);
    } catch (error, stack) {
      _logger.severe('Exporting logs failed', error, stack);
    }
  }

  Future<void> _handleInitData(InitDataEvent event, Emitter<DevToolsState> emit) async {
    final isDeveloper = await _devToolsService.isDeveloper();
    final syncStats = await _devToolsService.getStats();
    final areLogsOptionsAvailable = _loggingService != null;
    final loggingSettings = await _loggingService?.getSettings();
    final activeCampaign = await _campaignService.getActiveCampaign();
    final allCampaigns = await _campaignService.getAllCampaigns();

    emit(
      state.copyWith(
        isDeveloper: isDeveloper,
        syncStats: Optional(syncStats),
        areLogsOptionsAvailable: areLogsOptionsAvailable,
        logsLevel: Optional(loggingSettings?.effectiveLevel),
        collectLogs: loggingSettings?.effectiveCollectLogs ?? false,
        campaign: DevToolsCampaignState(
          activeCampaign: activeCampaign,
          allCampaigns: allCampaigns,
        ),
      ),
    );
  }

  Future<void> _handleStopWatchingActiveCampaign(
    StopWatchingActiveCampaignEvent event,
    Emitter<DevToolsState> emit,
  ) async {
    await _activeCampaignSub?.cancel();
    _activeCampaignSub = null;
  }

  Future<void> _handleStopWatchingDocuments(
    StopWatchingDocumentsEvent event,
    Emitter<DevToolsState> emit,
  ) async {
    await _documentsCountSub?.cancel();
    _documentsCountSub = null;
  }

  Future<void> _handleStopWatchingSystemInfo(
    StopWatchingSystemInfoEvent event,
    Emitter<DevToolsState> emit,
  ) async {
    await _syncStartsSub?.cancel();
    _syncStartsSub = null;
  }

  void _handleSyncDocuments(SyncDocumentsEvent event, Emitter<DevToolsState> emit) {
    final activeCampaign = state.campaign.activeCampaign;
    if (activeCampaign == null) {
      return;
    }
    // Non periodic request, no need to cancel periodic one.
    _syncManager.queue(CampaignSyncRequest(activeCampaign));
  }

  void _handleSyncStatsChanged(SyncStatsChangedEvent event, Emitter<DevToolsState> emit) {
    emit(state.copyWith(syncStats: Optional(event.stats)));
  }

  void _handleTapCountReset(DevToolsEnablerTapResetEvent event, Emitter<DevToolsState> emit) {
    _resetCountTimer?.cancel();
    _resetCountTimer = null;

    emit(state.copyWith(enableTapCount: 0));
  }

  Future<void> _handleWatchActiveCampaign(
    WatchActiveCampaignEvent event,
    Emitter<DevToolsState> emit,
  ) async {
    _activeCampaignSub = _campaignService.watchActiveCampaign.listen((value) {
      add(ActiveCampaignChangedEvent(value));
    });
  }

  Future<void> _handleWatchDocuments(
    WatchDocumentsEvent event,
    Emitter<DevToolsState> emit,
  ) async {
    _documentsCountSub = _documentsService.watchCount().listen(
      (event) => add(DocumentsCountChangedEvent(event)),
    );
  }

  Future<void> _handleWatchSystemInfo(
    WatchSystemInfoEvent event,
    Emitter<DevToolsState> emit,
  ) async {
    _syncStartsSub = _devToolsService.watchStats().listen(
      (event) => add(SyncStatsChangedEvent(event)),
    );
  }

  void _updateDocumentsCountChanged(DocumentsCountChangedEvent event, Emitter<DevToolsState> emit) {
    emit(state.copyWith(documentsCount: Optional(event.count)));
  }
}
