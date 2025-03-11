import 'dart:async';

import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:synchronized/synchronized.dart';

final _logger = Logger('SyncManager');

abstract interface class SyncManager {
  factory SyncManager(DocumentsService documentsService) = SyncManagerImpl;

  Future<void> dispose();

  Future<void> start();
}

final class SyncManagerImpl implements SyncManager {
  final DocumentsService _documentsService;

  final _lock = Lock();

  Timer? _syncTimer;

  SyncManagerImpl(
    this._documentsService,
  );

  @override
  Future<void> dispose() async {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  @override
  Future<void> start() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) {
        _logger.finest('Scheduled synchronization starts');
        // ignore: discarded_futures
        _lock.synchronized(_startSynchronization).ignore();
      },
    );

    return _lock.synchronized(_startSynchronization);
  }

  Future<void> _startSynchronization() async {
    final stopwatch = Stopwatch()..start();

    try {
      _logger.fine('Synchronization started');

      final newRefs = await _documentsService.sync(
        onProgress: (value) {
          _logger.finest('Documents sync progress[$value]');
        },
      );

      _logger.fine('Synchronization completed. NewRefs[${newRefs.length}]');
    } catch (error, stack) {
      _logger.severe('Synchronization failed', error, stack);
      rethrow;
    } finally {
      stopwatch.stop();

      _logger.fine('Synchronization took ${stopwatch.elapsed}');
    }
  }
}
