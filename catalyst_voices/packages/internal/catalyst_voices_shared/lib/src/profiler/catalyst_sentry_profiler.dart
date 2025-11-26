import 'dart:async';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final class CatalystSentryProfiler implements CatalystProfiler {
  const CatalystSentryProfiler();

  @override
  CatalystProfilerTimeline startTransaction(
    String name, {
    CatalystProfilerTimelineArguments? arguments,
  }) {
    final span = Sentry.startTransaction(
      name,
      arguments?.operation ?? 'operation',
      description: arguments?.description,
      startTimestamp: arguments?.startTimestamp,
    );

    return _SentryTimeline(span);
  }

  @override
  Future<void> time(
    String name,
    FutureOr<void> Function() body, {
    CatalystProfilerTimelineArguments? arguments,
  }) async {
    final transaction = startTransaction(name, arguments: arguments);
    final clock = Stopwatch();
    final finishArgs = CatalystProfilerTimelineFinishArguments();

    try {
      clock.start();
      await body();
      finishArgs.status = 'completed';
    } catch (error) {
      finishArgs
        ..throwable = error
        ..status = 'failed';
    } finally {
      finishArgs.took = clock.elapsed;

      unawaited(transaction.finish(arguments: finishArgs));
    }
  }

  @override
  Future<T> timeWithResult<T>(
    String name,
    FutureOr<T> Function() body, {
    CatalystProfilerTimelineArguments? arguments,
    bool debounce = false,
  }) async {
    final transaction = startTransaction(name, arguments: arguments);
    final clock = Stopwatch();
    final finishArgs = CatalystProfilerTimelineFinishArguments();

    try {
      clock.start();
      final result = await body();
      finishArgs.status = 'completed';
      return result;
    } catch (error) {
      finishArgs
        ..throwable = error
        ..status = 'failed';
      rethrow;
    } finally {
      finishArgs.took = clock.elapsed;

      unawaited(transaction.finish(arguments: finishArgs));
    }
  }
}

final class _SentryTask implements CatalystProfilerTimelineTask {
  final ISentrySpan _span;

  _SentryTask(this._span);

  @override
  Future<void> finish({CatalystProfilerTimelineTaskFinishArguments? arguments}) {
    final status = arguments?.status;
    final hint = arguments?.hint;

    if (arguments?.took case final value?) {
      _span.setMeasurement(
        'took',
        value.inMilliseconds,
        unit: DurationSentryMeasurementUnit.milliSecond,
      );
    }

    _span.throwable = arguments?.throwable;

    return _span.finish(
      status: status != null ? SpanStatus.fromString(status) : null,
      endTimestamp: arguments?.endTimestamp,
      hint: hint is Hint ? hint : null,
    );
  }

  @override
  CatalystProfilerTimelineTask startTask(
    String name, {
    CatalystProfilerTimelineTaskArguments? arguments,
  }) {
    final taskSpan = _span.startChild(
      name,
      description: arguments?.description,
      startTimestamp: arguments?.startTimestamp,
    );

    return _SentryTask(taskSpan);
  }
}

final class _SentryTimeline implements CatalystProfilerTimeline {
  final ISentrySpan _span;

  _SentryTimeline(this._span);

  @override
  bool get finished => _span.finished;

  @override
  Future<void> finish({CatalystProfilerTimelineFinishArguments? arguments}) {
    if (arguments?.took case final value?) {
      _span.setMeasurement(
        'took',
        value.inMilliseconds,
        unit: DurationSentryMeasurementUnit.milliSecond,
      );
    }

    _span.throwable = arguments?.throwable;

    final status = arguments?.status;
    final hint = arguments?.hint;

    return _span.finish(
      status: status != null ? SpanStatus.fromString(status) : null,
      endTimestamp: arguments?.endTimestamp,
      hint: hint is Hint ? hint : null,
    );
  }

  @override
  CatalystProfilerTimelineTask startTask(
    String name, {
    CatalystProfilerTimelineTaskArguments? arguments,
  }) {
    final taskSpan = _span.startChild(
      name,
      description: arguments?.description,
      startTimestamp: arguments?.startTimestamp,
    );

    return _SentryTask(taskSpan);
  }

  @override
  Future<void> time(
    String name,
    AsyncOrValueGetter<void> body, {
    CatalystProfilerTimelineTaskArguments? arguments,
  }) async {
    final task = startTask(name, arguments: arguments);
    final clock = Stopwatch();
    final finishArgs = CatalystProfilerTimelineTaskFinishArguments();

    try {
      clock.start();
      await body();
      finishArgs.status = 'completed';
    } catch (error) {
      finishArgs
        ..throwable = error
        ..status = 'failed';
    } finally {
      finishArgs.took = clock.elapsed;

      unawaited(task.finish(arguments: finishArgs));
    }
  }

  @override
  Future<T> timeWithResult<T>(
    String name,
    AsyncOrValueGetter<T> body, {
    CatalystProfilerTimelineTaskArguments? arguments,
  }) async {
    final task = startTask(name, arguments: arguments);
    final clock = Stopwatch();
    final finishArgs = CatalystProfilerTimelineTaskFinishArguments();

    try {
      clock.start();
      final result = await body();
      finishArgs.status = 'completed';
      return result;
    } catch (error) {
      finishArgs
        ..throwable = error
        ..status = 'failed';
      rethrow;
    } finally {
      finishArgs.took = clock.elapsed;

      unawaited(task.finish(arguments: finishArgs));
    }
  }
}
