import 'dart:async';

import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

final _logger = Logger('SyncManager');

abstract interface class SyncManager {
  factory SyncManager(DocumentsService documentsService) = SyncManagerImpl;

  Future<void> dispose();

  Future<void> start();
}

final class SyncManagerImpl implements SyncManager {
  final DocumentsService _documentsService;

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
  Future<void> start() async {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) {
        _logger.finest('Scheduled synchronization starts');
        // ignore: discarded_futures
        _startSynchronization().ignore();
      },
    );

    await _startSynchronization();
  }

  Future<void> _startSynchronization() async {
    try {
      _logger.fine('Synchronization started');

      await _syncDocuments();

      _logger.fine('Synchronization completed');
    } catch (error, stack) {
      _logger.severe('Synchronization failed', error, stack);
    } finally {
      _logger.fine('Synchronization ended');
    }
  }

  Future<void> _syncDocuments() async {
    final completer = Completer<double>();

    _documentsService.sync().listen(
      (progress) {
        _logger.finest('Documents sync progress $progress');
      },
      onDone: () {
        _logger.finest('Documents sync completed');

        completer.complete(1);
      },
      onError: (Object error, StackTrace stack) {
        _logger.severe('Documents sync failed', error, stack);

        completer.completeError(error, stack);
      },
      cancelOnError: true,
    );

    await completer.future;
  }
}
