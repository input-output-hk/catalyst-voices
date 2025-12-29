import 'dart:async';
import 'dart:collection';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:synchronized/synchronized.dart';

final _logger = Logger('SyncManager');

/// [SyncManager] provides synchronization functionality for documents.
abstract interface class SyncManager {
  factory SyncManager(
    DocumentsSynchronizer synchronizer,
    SyncStatsStorage statsStorage,
    CatalystProfiler profiler,
  ) = SyncManagerImpl;

  ///
  DocumentsSyncRequest? get activeRequest;

  /// Stream of synchronization progress (0.0 to 1.0) for current request.
  Stream<double> get activeRequestProgress;

  ///
  List<DocumentsSyncRequest> get pendingRequests;

  ///
  Future<bool> get waitForActiveRequest;

  ///
  Future<void> dispose();

  ///
  void queue(DocumentsSyncRequest request);
}

final class SyncManagerImpl implements SyncManager {
  final DocumentsSynchronizer _synchronizer;
  final SyncStatsStorage _statsStorage;
  final CatalystProfiler _profiler;

  final _lock = Lock();
  final _activeSyncProgressSC = StreamController<double>.broadcast();

  final _requestsQueue = Queue<DocumentsSyncRequest>();
  final _scheduledRequestsTimers = <DocumentsSyncRequest, Timer>{};

  DocumentsSyncRequest? _activeRequest;
  Completer<bool>? _activeRequestCompleter;

  bool _isDisposed = false;

  SyncManagerImpl(
    this._synchronizer,
    this._statsStorage,
    this._profiler,
  );

  @override
  DocumentsSyncRequest? get activeRequest => _activeRequest;

  @override
  Stream<double> get activeRequestProgress => _activeSyncProgressSC.stream;

  @override
  List<DocumentsSyncRequest> get pendingRequests => List.unmodifiable(_requestsQueue);

  @override
  Future<bool> get waitForActiveRequest => _activeRequestCompleter?.future ?? Future.value(true);

  bool get _isActive => _activeRequest != null;

  @override
  Future<void> dispose() async {
    _isDisposed = true;

    // Make copy so to be sure map won't change while iterating
    final scheduledRequestsTimers = Map.of(_scheduledRequestsTimers);
    for (final timer in scheduledRequestsTimers.values) {
      timer.cancel();
    }
    _scheduledRequestsTimers.clear();

    await _activeSyncProgressSC.close();
  }

  @override
  void queue(DocumentsSyncRequest request) {
    if (_isDisposed) {
      _logger.warning('Tried to queue sync request on disposed manager');
      return;
    }

    if (request.isPeriodic) {
      _scheduleRequest(request, periodic: request.periodic!);
    }

    _logger.finer('Queueing $request');
    _requestsQueue.addLast(request);
    _next();
  }

  Future<void> _execute(DocumentsSyncRequest request) async {
    _activeRequest = request;
    final completer = Completer<bool>();
    _activeRequestCompleter = completer;

    final timeline = _profiler.startTransaction('sync-$request');
    final timelineArgs = CatalystProfilerTimelineFinishArguments();
    final stopwatch = Stopwatch()..start();

    var syncResult = const DocumentsSyncResult();

    try {
      _logger.fine('Executing $request');

      _updateProgress(0);

      syncResult = await _synchronizer.start(request, onProgress: _updateProgress);

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
      _updateProgress(1);

      stopwatch.stop();
      timelineArgs.took = stopwatch.elapsed;

      await timeline.finish(arguments: timelineArgs);
      await _updateSuccessfulSyncStats(
        newRefsCount: syncResult.newDocumentsCount,
        duration: stopwatch.elapsed,
      );

      _activeRequest = null;
      _activeRequestCompleter = null;
    }
  }

  void _next() {
    if (_isActive || _isDisposed) return;
    if (_requestsQueue.isEmpty) {
      _logger.finer('No more pending requests');
      return;
    }

    final request = _requestsQueue.removeFirst();

    unawaited(_lock.synchronized(() => _execute(request)).whenComplete(_next));
  }

  void _scheduleRequest(
    DocumentsSyncRequest request, {
    required Duration periodic,
  }) {
    assert(request.isPeriodic, 'Schedule only periodic tasks');

    if (_scheduledRequestsTimers.containsKey(request)) {
      _logger.finer('$request already has scheduled timer');
      return;
    }

    final timer = Timer.periodic(request.periodic!, (timer) {
      if (timer.isActive) {
        final oneTimeRequest = request.copyWith(periodic: const Optional.empty());
        _logger.info('Queueing schedule sync $oneTimeRequest');
        queue(oneTimeRequest);
      }
    });

    _scheduledRequestsTimers[request] = timer;
  }

  void _updateProgress(double progress) {
    if (!_activeSyncProgressSC.isClosed) {
      _activeSyncProgressSC.add(progress);
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
