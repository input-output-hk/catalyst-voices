import 'dart:async';

import 'package:catalyst_voices_shared/src/profiler/profiler.dart';
import 'package:catalyst_voices_shared/src/utils/typedefs.dart';

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
  Future<void> finish({CatalystProfilerTimelineTaskFinishArguments? arguments}) async {
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
  bool get finished => false;

  @override
  Future<void> finish({CatalystProfilerTimelineFinishArguments? arguments}) async {
    // noop
  }

  @override
  CatalystProfilerTimelineTask startTask(
    String name, {
    CatalystProfilerTimelineTaskArguments? arguments,
  }) {
    return _NoopTask();
  }

  @override
  Future<void> time(
    String name,
    AsyncOrValueGetter<void> body, {
    CatalystProfilerTimelineTaskArguments? arguments,
  }) async {
    return body();
  }
}
