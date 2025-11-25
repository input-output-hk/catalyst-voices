import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:synchronized/synchronized.dart';

final _logger = Logger('SyncManager');

/// [SyncManager] provides synchronization functionality for documents.
abstract interface class SyncManager {
  factory SyncManager(
    AppMetaStorage appMetaStorage,
    SyncStatsStorage statsStorage,
    DocumentsService documentsService,
    CampaignService campaignService,
    CatalystProfiler profiler,
  ) = SyncManagerImpl;

  /// Stream of synchronization progress (0.0 to 1.0).
  Stream<double> get progressStream;

  Future<bool> get waitForSync;

  Future<void> dispose();

  Future<void> start();
}

final class SyncManagerImpl implements SyncManager {
  final AppMetaStorage _appMetaStorage;
  final SyncStatsStorage _statsStorage;
  final DocumentsService _documentsService;
  final CampaignService _campaignService;
  final CatalystProfiler _profiler;

  final _lock = Lock();
  final _progressController = StreamController<double>.broadcast();

  Timer? _syncTimer;
  var _synchronizationCompleter = Completer<bool>();

  SyncManagerImpl(
    this._appMetaStorage,
    this._statsStorage,
    this._documentsService,
    this._campaignService,
    this._profiler,
  );

  @override
  Stream<double> get progressStream => _progressController.stream;

  @override
  Future<bool> get waitForSync => _synchronizationCompleter.future;

  @override
  Future<void> dispose() async {
    _syncTimer?.cancel();
    _syncTimer = null;

    if (!_synchronizationCompleter.isCompleted) {
      _synchronizationCompleter.complete(false);
    }

    await _progressController.close();
  }

  @override
  Future<void> start() {
    if (_lock.locked) {
      _logger.finest('Synchronization in progress');
      return Future(() {});
    }

    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(
      const Duration(minutes: 15),
      (_) {
        _logger.finest('Scheduled synchronization starts');
        // ignore: discarded_futures
        _lock.synchronized(_startSynchronization).ignore();
      },
    );
    return _lock.synchronized(_startSynchronization);
  }

  Future<void> _startSynchronization() async {
    if (_synchronizationCompleter.isCompleted) {
      _synchronizationCompleter = Completer();
    }

    final timeline = _profiler.startTransaction('sync');
    final timelineArgs = CatalystProfilerTimelineFinishArguments();
    final stopwatch = Stopwatch()..start();

    var syncResult = const DocumentsSyncResult();

    try {
      _logger.fine('Synchronization started');

      // This means when campaign will become document we'll have get it first
      // with separate request
      final activeCampaign = await _updateActiveCampaign();
      if (activeCampaign == null) {
        _logger.finer('No active campaign found!');
        return;
      }

      if (!_progressController.isClosed) {
        _progressController.add(0);
      }

      syncResult = await _documentsService.sync(
        campaign: activeCampaign,
        onProgress: (value) {
          if (!_progressController.isClosed) {
            _progressController.add(value);
          }
        },
      );

      unawaited(timeline.finish());

      _logger.fine('Synchronization completed. New documents: ${syncResult.newDocumentsCount}');

      if (syncResult.failedDocumentsCount > 0) {
        _logger.info('Synchronization failed for documents: ${syncResult.failedDocumentsCount}');
      }

      timelineArgs
        ..status = 'success'
        ..hint =
            'new docs[${syncResult.newDocumentsCount}], '
            'failed docs[${syncResult.failedDocumentsCount}]';

      _synchronizationCompleter.complete(true);
    } catch (error, stack) {
      _logger.fine('Synchronization failed', error, stack);

      timelineArgs
        ..status = 'failed'
        ..throwable = error;

      _synchronizationCompleter.complete(false);

      rethrow;
    } finally {
      if (!_progressController.isClosed) {
        _progressController.add(1);
      }

      stopwatch.stop();
      timelineArgs.took = stopwatch.elapsed;

      await timeline.finish(arguments: timelineArgs);
      await _updateSuccessfulSyncStats(
        newRefsCount: syncResult.newDocumentsCount,
        duration: stopwatch.elapsed,
      );
    }
  }

  Future<Campaign?> _updateActiveCampaign() async {
    final appMeta = await _appMetaStorage.read();
    final activeCampaign = await _campaignService.getActiveCampaign();

    final previous = appMeta.activeCampaign;
    final current = activeCampaign?.id;

    if (previous == current) {
      return activeCampaign;
    }

    _logger.fine('Active campaign changed from [$previous] to [$current]!');

    final updatedAppMeta = appMeta.copyWith(activeCampaign: Optional(current));
    await _appMetaStorage.write(updatedAppMeta);
    await _documentsService.clear(keepLocalDrafts: true);

    return activeCampaign;
  }

  Future<void> _updateSuccessfulSyncStats({
    required int newRefsCount,
    required Duration duration,
  }) async {
    final stats = (await _statsStorage.read()) ?? const SyncStats();

    final updated = stats.copyWith(
      lastSuccessfulSyncAt: Optional(DateTimeExt.now()),
      lastAddedRefsCount: Optional(newRefsCount),
      lastSyncDuration: Optional(duration),
    );

    await _statsStorage.write(updated);
  }
}
