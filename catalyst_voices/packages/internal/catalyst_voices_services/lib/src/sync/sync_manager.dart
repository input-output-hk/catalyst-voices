import 'dart:async';
import 'dart:collection';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:synchronized/extension.dart';
import 'package:synchronized/synchronized.dart';

final _logger = Logger('SyncManager');

typedef SyncRequestPredicate = bool Function(DocumentsSyncRequest request);

typedef SyncRequestProgress = ({DocumentsSyncRequest request, double progress});

/// [SyncManager] provides synchronization functionality for documents.
abstract interface class SyncManager {
  factory SyncManager(
    DocumentsSynchronizer synchronizer,
    SyncStatsStorage statsStorage,
    CatalystProfiler profiler,
  ) = SyncManagerImpl;

  /// Stream of synchronization progress (0.0 to 1.0) for current request.
  Stream<SyncRequestProgress> get progressStream;

  Future<void> dispose();

  void queue(DocumentsSyncRequest request);

  Future<bool> waitForSync({
    required SyncRequestPredicate predicate,
  });
}

final class SyncManagerImpl implements SyncManager {
  final DocumentsSynchronizer _synchronizer;
  final SyncStatsStorage _statsStorage;
  final CatalystProfiler _profiler;

  final _lock = Lock();
  final _progressController = StreamController<SyncRequestProgress>.broadcast();

  final _requestsQueue = Queue<DocumentsSyncRequest>();
  final _requestsCompleters = <DocumentsSyncRequest, Completer<bool>>{};

  Timer? _syncTimer;
  bool _isDisposed = false;

  SyncManagerImpl(
    this._synchronizer,
    this._statsStorage,
    this._profiler,
  );

  @override
  Stream<SyncRequestProgress> get progressStream => _progressController.stream;

  @override
  Future<void> dispose() async {
    _syncTimer?.cancel();
    _syncTimer = null;

    if (!_synchronizationCompleter.isCompleted) {
      _synchronizationCompleter.complete(false);
    }

    await _progressController.close();

    _isDisposed = true;
  }

  @override
  void queue(DocumentsSyncRequest request) {
    if (request.isPeriodic) {
      _scheduleRequest(request, periodic: request.periodic!);
      return;
    }

    _requestsQueue.addLast(request);

    if (!_lock.inLock) _next();
  }

  @override
  Future<bool> waitForSync({
    required SyncRequestPredicate predicate,
  }) {
    // TODO: implement waitCompletion
    throw UnimplementedError();
  }

  Future<void> _execute(DocumentsSyncRequest request) async {
    final completer = Completer<bool>();

    final timeline = _profiler.startTransaction('sync-$request');
    final timelineArgs = CatalystProfilerTimelineFinishArguments();
    final stopwatch = Stopwatch()..start();

    var syncResult = const DocumentsSyncResult();

    try {
      _logger.fine('Executing $request');

      _updateProgress(request, 0);

      syncResult = await _synchronizer.start(
        request,
        onProgress: (value) => _updateProgress(request, value),
      );

      unawaited(timeline.finish());

      _logger.fine('Completed $request. New documents: ${syncResult.newDocumentsCount}');

      if (syncResult.failedDocumentsCount > 0) {
        _logger.info('$request failed documents: ${syncResult.failedDocumentsCount}');
      }

      timelineArgs
        ..status = 'success'
        ..hint =
            'new docs[${syncResult.newDocumentsCount}], '
            'failed docs[${syncResult.failedDocumentsCount}]';

      completer.complete(true);
    } catch (error, stack) {
      _logger.fine('$request failed', error, stack);

      timelineArgs
        ..status = 'failed'
        ..throwable = error;

      completer.complete(false);
    } finally {
      _updateProgress(request, 1);

      stopwatch.stop();
      timelineArgs.took = stopwatch.elapsed;

      await timeline.finish(arguments: timelineArgs);
      await _updateSuccessfulSyncStats(
        newRefsCount: syncResult.newDocumentsCount,
        duration: stopwatch.elapsed,
      );
    }
  }

  void _next() {
    if (_requestsQueue.isEmpty || _isDisposed) return;
    final request = _requestsQueue.removeFirst();

    unawaited(_lock.synchronized(() => _execute(request)).whenComplete(_next));
  }

  void _scheduleRequest(
    DocumentsSyncRequest request, {
    required Duration periodic,
  }) {
    assert(request.isPeriodic, 'Schedule only periodic tasks');
  }

  void _updateProgress(DocumentsSyncRequest request, double progress) {
    if (!_progressController.isClosed) {
      _progressController.add((request: request, progress: progress));
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
