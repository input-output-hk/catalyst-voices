import 'dart:async';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final class CatalystSentryProfiler implements CatalystProfiler {
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

    return CatalystSentryProfilerTimeline(span);
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
    } catch (error) {
      finishArgs.throwable = error;
    } finally {
      finishArgs.took = clock.elapsed;

      transaction.finish(arguments: finishArgs);
    }
  }
}

final class CatalystSentryProfilerTimeline implements CatalystProfilerTimeline {
  final ISentrySpan _span;

  CatalystSentryProfilerTimeline(this._span);

  @override
  FutureOr<void> finish({CatalystProfilerTimelineFinishArguments? arguments}) {
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

    return CatalystSentryProfilerTimelineTask(taskSpan);
  }
}

final class CatalystSentryProfilerTimelineTask implements CatalystProfilerTimelineTask {
  final ISentrySpan _span;

  CatalystSentryProfilerTimelineTask(this._span);

  @override
  FutureOr<void> finish({CatalystProfilerTimelineTaskFinishArguments? arguments}) {
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

    return CatalystSentryProfilerTimelineTask(taskSpan);
  }
}
