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
    SyncStatsStorage statsStorage,
    DocumentsService documentsService,
  ) = SyncManagerImpl;

  Future<bool> get isSynchronization;

  Future<void> dispose();

  Future<void> start();
}

final class SyncManagerImpl implements SyncManager {
  final SyncStatsStorage _statsStorage;
  final DocumentsService _documentsService;

  final _lock = Lock();

  Timer? _syncTimer;
  var _isSynchronizationCompleter = Completer<bool>();

  SyncManagerImpl(
    this._statsStorage,
    this._documentsService,
  );

  @override
  Future<bool> get isSynchronization => _isSynchronizationCompleter.future;

  @override
  Future<void> dispose() async {
    _syncTimer?.cancel();
    _syncTimer = null;

    if (!_isSynchronizationCompleter.isCompleted) {
      _isSynchronizationCompleter.complete(false);
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
    if (_isSynchronizationCompleter.isCompleted) {
      _isSynchronizationCompleter = Completer();
    }

    final stopwatch = Stopwatch()..start();

    try {
      _logger.fine('Synchronization started');

      final newRefs = await _documentsService.sync(
        onProgress: (value) {
          _logger.finest('Documents sync progress[$value]');
        },
      );

      stopwatch.stop();

      _logger.fine('Synchronization took ${stopwatch.elapsed}');

      await _updateSuccessfulSyncStats(
        newRefsCount: newRefs.length,
        duration: stopwatch.elapsed,
      );

      _logger.fine('Synchronization completed. NewRefs[${newRefs.length}]');

      _isSynchronizationCompleter.complete(true);
    } catch (error, stack) {
      stopwatch.stop();

      _logger.severe('Synchronization failed after ${stopwatch.elapsed}', error, stack);

      _isSynchronizationCompleter.complete(false);

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
