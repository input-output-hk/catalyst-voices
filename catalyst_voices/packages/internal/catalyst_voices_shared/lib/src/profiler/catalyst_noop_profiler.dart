import 'dart:async';

import 'package:catalyst_voices_shared/src/profiler/profiler.dart';

final class CatalystNoopProfiler implements CatalystProfiler {
  const CatalystNoopProfiler();

  @override
  CatalystProfilerTimeline startTransaction(
    String name, {
    CatalystProfilerTimelineArguments? arguments,
  }) {
    return _NoopTimeline();
  }

  @override
  Future<void> time(
    String name,
    FutureOr<void> Function() body, {
    CatalystProfilerTimelineArguments? arguments,
  }) async {
    return body();
  }
}

final class _NoopTask implements CatalystProfilerTimelineTask {
  @override
  FutureOr<void> finish({CatalystProfilerTimelineTaskFinishArguments? arguments}) {
    // noop
  }

  @override
  CatalystProfilerTimelineTask startTask(
    String name, {
    CatalystProfilerTimelineTaskArguments? arguments,
  }) {
    return _NoopTask();
  }
}

final class _NoopTimeline implements CatalystProfilerTimeline {
  @override
  FutureOr<void> finish({CatalystProfilerTimelineFinishArguments? arguments}) {
    // noop
  }

  @override
  CatalystProfilerTimelineTask startTask(
    String name, {
    CatalystProfilerTimelineTaskArguments? arguments,
  }) {
    return _NoopTask();
  }
}
