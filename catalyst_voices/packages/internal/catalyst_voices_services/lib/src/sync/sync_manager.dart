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
  ) = SyncManagerImpl;

  Future<bool> get waitForSync;

  Future<void> dispose();

  Future<void> start();
}

final class SyncManagerImpl implements SyncManager {
  final AppMetaStorage _appMetaStorage;
  final SyncStatsStorage _statsStorage;
  final DocumentsService _documentsService;
  final CampaignService _campaignService;

  final _lock = Lock();

  Timer? _syncTimer;
  var _synchronizationCompleter = Completer<bool>();

  SyncManagerImpl(
    this._appMetaStorage,
    this._statsStorage,
    this._documentsService,
    this._campaignService,
  );

  @override
  Future<bool> get waitForSync => _synchronizationCompleter.future;

  @override
  Future<void> dispose() async {
    _syncTimer?.cancel();
    _syncTimer = null;

    if (!_synchronizationCompleter.isCompleted) {
      _synchronizationCompleter.complete(false);
    }
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

    final stopwatch = Stopwatch()..start();
    try {
      _logger.fine('Synchronization started');

      // This means when campaign will become document we'll have get it first
      // with separate request
      final activeCampaign = await _updateActiveCampaign();
      if (activeCampaign == null) {
        _logger.finer('No active campaign found!');
        return;
      }

      final newRefs = await _documentsService.sync(
        campaign: activeCampaign,
        onProgress: (value) {
          _logger.finest('Documents sync progress[$value]');
        },
      );

      await _updateSuccessfulSyncStats(
        newRefsCount: newRefs.length,
        duration: stopwatch.elapsed,
      );

      _logger.fine('Synchronization completed. NewRefs[${newRefs.length}]');
      _synchronizationCompleter.complete(true);
    } catch (error, stack) {
      _logger.severe('Synchronization failed', error, stack);
      _synchronizationCompleter.complete(false);

      rethrow;
    } finally {
      stopwatch.stop();

      _logger.fine('Synchronization took ${stopwatch.elapsed}');
    }
  }

  Future<Campaign?> _updateActiveCampaign() async {
    final appMeta = await _appMetaStorage.read();
    final activeCampaign = await _campaignService.getActiveCampaign();

    final previous = appMeta.activeCampaign;
    final current = activeCampaign?.selfRef;

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
