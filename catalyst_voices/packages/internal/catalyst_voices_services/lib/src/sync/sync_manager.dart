import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:synchronized/synchronized.dart';

final _logger = Logger('SyncManager');

/// [SyncManager] provides synchronization functionality for documents.
abstract interface class SyncManager {
  factory SyncManager(
    SyncStatsStorage statsStorage,
    DocumentsService documentsService,
  ) = SyncManagerImpl;

  Future<bool> get waitForSync;

  Future<void> dispose();

  Future<void> start();
}

final class SyncManagerImpl implements SyncManager {
  final SyncStatsStorage _statsStorage;
  final DocumentsService _documentsService;

  final _lock = Lock();

  Timer? _syncTimer;
  var _synchronizationCompleter = Completer<bool>();

  SyncManagerImpl(
    this._statsStorage,
    this._documentsService,
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
      debugPrint('Synchronization in progress');
      return Future(() {});
    }

    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(
      const Duration(minutes: 15),
      (_) {
        debugPrint('Scheduled synchronization starts');
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
      debugPrint('Synchronization started');

      final newRefs = await _documentsService.sync(
        onProgress: (value) {
          debugPrint('Documents sync progress[$value]');
        },
      );

      stopwatch.stop();

      debugPrint('Synchronization took ${stopwatch.elapsed}');

      await _updateSuccessfulSyncStats(
        newRefsCount: newRefs.length,
        duration: stopwatch.elapsed,
      );

      debugPrint('Synchronization completed. NewRefs[${newRefs.length}]');
      _synchronizationCompleter.complete(true);
    } catch (error, stack) {
      stopwatch.stop();

      debugPrint(
        'Synchronization failed after ${stopwatch.elapsed}, $error',
      );
      _synchronizationCompleter.complete(false);

      rethrow;
    }
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
