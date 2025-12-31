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

  /// Returns the currently executing [DocumentsSyncRequest], if any.
  DocumentsSyncRequest? get activeRequest;

  /// Stream of synchronization progress (0.0 to 1.0) for current request.
  Stream<double> get activeRequestProgress;

  /// Returns a list of [DocumentsSyncRequest] currently waiting in the queue.
  Iterable<DocumentsSyncRequest> get pendingRequests;

  /// returns a list of [DocumentsSyncRequest] currently have recurring timer.
  Iterable<DocumentsSyncRequest> get scheduledRequests;

  /// A future that completes when the [activeRequest] finishes.
  Future<bool> get waitForActiveRequest;

  /// Removes [request] from pending and scheduled lists.
  void cancel(DocumentsSyncRequest request);

  /// Adds [request] to the top of processing queue.
  ///
  /// Returned future will complete when [request] is processed.
  Future<bool> complete(DocumentsSyncRequest request);

  /// Cleans up resources, cancels timers, and closes streams.
  Future<void> dispose();

  /// Adds a [request] to the processing queue.
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
  final _requestsCompleters = <DocumentsSyncRequest, Completer<bool>>{};

  DocumentsSyncRequest? _activeRequest;

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
  Iterable<DocumentsSyncRequest> get pendingRequests => List.unmodifiable(_requestsQueue);

  @override
  Iterable<DocumentsSyncRequest> get scheduledRequests {
    return List.unmodifiable(_scheduledRequestsTimers.keys);
  }

  @override
  Future<bool> get waitForActiveRequest {
    return _requestsCompleters[_activeRequest]?.future ?? Future.value(false);
  }

  bool get _isActive => _activeRequest != null;

  @override
  void cancel(DocumentsSyncRequest request) {
    _requestsQueue.remove(request);
    _scheduledRequestsTimers.remove(request)?.cancel();
  }

  @override
  Future<bool> complete(DocumentsSyncRequest request) {
    final completer = Completer<bool>();
    _requestsCompleters[request] = completer;

    queue(request, priority: true);

    return completer.future;
  }

  @override
  Future<void> dispose() async {
    _isDisposed = true;

    for (final timer in _scheduledRequestsTimers.values) {
      timer.cancel();
    }
    _scheduledRequestsTimers.clear();

    await _activeSyncProgressSC.close();
  }

  @override
  void queue(
    DocumentsSyncRequest request, {
    bool priority = false,
  }) {
    if (_isDisposed) {
      _logger.warning('Tried to queue sync request on disposed manager');
      return;
    }

    if (request.isPeriodic) {
      _scheduleRequest(request, periodic: request.periodic!);
    }

    _logger.finer('Queueing $request');

    if (priority) {
      _requestsQueue.addFirst(request);
    } else {
      _requestsQueue.addLast(request);
    }

    _next();
  }

  /// Processes a single [request].
  Future<void> _execute(DocumentsSyncRequest request) async {
    _activeRequest = request;
    final completer = _requestsCompleters.putIfAbsent(request, Completer<bool>.new);

    final timeline = _profiler.startTransaction('sync-$request');
    final timelineArgs = CatalystProfilerTimelineFinishArguments();
    final stopwatch = Stopwatch()..start();

    late bool isSuccess;

    try {
      _logger.fine('Executing $request');

      _updateProgress(0);

      final result = await _synchronizer.start(request, onProgress: _updateProgress);

      unawaited(timeline.finish());

      _logger.fine('Completed $request. New documents: ${result.newDocumentsCount}');

      if (result.failedDocumentsCount > 0) {
        _logger.info('$request failed documents: ${result.failedDocumentsCount}');
      }

      timelineArgs
        ..status = 'success'
        ..hint =
            'new docs[${result.newDocumentsCount}], '
            'failed docs[${result.failedDocumentsCount}]';

      await _updateSuccessfulSyncStats(
        newRefsCount: result.newDocumentsCount,
        duration: stopwatch.elapsed,
      );

      isSuccess = true;
    } catch (error, stack) {
      _logger.fine('$request failed', error, stack);

      timelineArgs
        ..status = 'failed'
        ..throwable = error;

      isSuccess = false;
    } finally {
      _updateProgress(1);

      stopwatch.stop();
      timelineArgs.took = stopwatch.elapsed;

      await timeline.finish(arguments: timelineArgs);

      _activeRequest = null;
      _requestsCompleters.remove(request);

      completer.complete(isSuccess);
    }
  }

  /// Attempts to process the next item in the queue.
  void _next() {
    if (_isActive || _isDisposed) return;
    if (_requestsQueue.isEmpty) {
      _logger.finer('No more pending requests');
      return;
    }

    final request = _requestsQueue.removeFirst();

    // Use synchronized to ensure execution isolation
    unawaited(_lock.synchronized(() => _execute(request)).whenComplete(_next));
  }

  /// Sets up a periodic timer for recurring requests.
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
      if (!_isDisposed && timer.isActive) {
        // Strip periodicity for the instance added to the queue to avoid recursion
        final oneTimeRequest = request.copyWith(periodic: const Optional.empty());
        _logger.info('Queueing scheduled $oneTimeRequest');
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
