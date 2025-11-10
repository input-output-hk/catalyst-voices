import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';

final class CatalystConsoleProfiler implements CatalystProfiler {
  const CatalystConsoleProfiler();

  @override
  CatalystProfilerTimeline startTransaction(
    String name, {
    CatalystProfilerTimelineArguments? arguments,
  }) {
    return _Timeline(name, arguments: arguments);
  }

  @override
  Future<void> time(
    String name,
    AsyncOrValueGetter<void> body, {
    CatalystProfilerTimelineArguments? arguments,
  }) {
    return _Timeline(name, arguments: arguments).timeWithResult('', body);
  }

  @override
  Future<T> timeWithResult<T>(
    String name,
    AsyncOrValueGetter<T> body, {
    CatalystProfilerTimelineArguments? arguments,
  }) {
    return _Timeline(name, arguments: arguments).timeWithResult('', body);
  }
}

class _Timeline implements CatalystProfilerTimeline {
  final String name;
  final CatalystProfilerTimelineArguments? arguments;
  final Stopwatch _stopwatch;

  _Timeline(
    this.name, {
    this.arguments,
  }) : _stopwatch = Stopwatch()..start();

  @override
  bool get finished => !_stopwatch.isRunning;

  @override
  Future<void> finish({CatalystProfilerTimelineFinishArguments? arguments}) async {
    _stopwatch.stop();

    final buffer = StringBuffer(name);

    final startArgs = this.arguments?.toMap() ?? {};
    if (startArgs.isNotEmpty) {
      buffer.write(' $startArgs');
    }

    final effectiveArguments = (arguments ?? CatalystProfilerTimelineFinishArguments())
      ..took = _stopwatch.elapsed;

    final args = effectiveArguments.toMap();
    if (args.isNotEmpty) {
      buffer.write(' $args');
    }

    debugPrint('$buffer');
  }

  @override
  CatalystProfilerTimelineTask startTask(
    String name, {
    CatalystProfilerTimelineTaskArguments? arguments,
  }) {
    return _TimelineTask('${this.name}.$name', arguments: arguments);
  }

  @override
  Future<void> time(
    String name,
    AsyncOrValueGetter<void> body, {
    CatalystProfilerTimelineTaskArguments? arguments,
  }) {
    return timeWithResult(name, body, arguments: arguments);
  }

  @override
  Future<T> timeWithResult<T>(
    String name,
    AsyncOrValueGetter<T> body, {
    CatalystProfilerTimelineTaskArguments? arguments,
  }) async {
    final buffer = StringBuffer(name);
    final args = arguments?.toMap() ?? {};
    if (args.isNotEmpty) {
      buffer.write(' $args');
    }

    final stopwatch = Stopwatch()..start();
    try {
      return await body();
    } finally {
      stopwatch.stop();

      debugPrint('$buffer took ${stopwatch.elapsed}');
    }
  }
}

class _TimelineTask implements CatalystProfilerTimelineTask {
  final String name;
  final Stopwatch _stopwatch;
  final CatalystProfilerTimelineTaskArguments? arguments;

  _TimelineTask(
    this.name, {
    this.arguments,
  }) : _stopwatch = Stopwatch()..start();

  @override
  Future<void> finish({
    CatalystProfilerTimelineTaskFinishArguments? arguments,
  }) async {
    _stopwatch.stop();

    final buffer = StringBuffer(name);

    final effectiveArguments = arguments ?? CatalystProfilerTimelineTaskFinishArguments()
      ..took ??= _stopwatch.elapsed;

    final args = effectiveArguments.toMap();

    if (args.isNotEmpty) {
      buffer.write(' $args');
    }

    debugPrint('$buffer');
  }

  @override
  CatalystProfilerTimelineTask startTask(
    String name, {
    CatalystProfilerTimelineTaskArguments? arguments,
  }) {
    return _TimelineTask('${this.name}.$name', arguments: arguments);
  }
}
