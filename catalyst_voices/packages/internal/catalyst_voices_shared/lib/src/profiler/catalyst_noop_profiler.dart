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
    return const _NoopTimeline();
  }

  @override
  Future<void> time(
    String name,
    FutureOr<void> Function() body, {
    CatalystProfilerTimelineArguments? arguments,
  }) async {
    return body();
  }

  @override
  Future<T> timeWithResult<T>(
    String name,
    FutureOr<T> Function() body, {
    CatalystProfilerTimelineArguments? arguments,
    bool debounce = false,
  }) async {
    return body();
  }
}

final class _NoopTask implements CatalystProfilerTimelineTask {
  const _NoopTask();

  @override
  Future<void> finish({CatalystProfilerTimelineTaskFinishArguments? arguments}) async {
    // noop
  }

  @override
  CatalystProfilerTimelineTask startTask(
    String name, {
    CatalystProfilerTimelineTaskArguments? arguments,
  }) {
    return const _NoopTask();
  }
}

final class _NoopTimeline implements CatalystProfilerTimeline {
  const _NoopTimeline();

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
    return const _NoopTask();
  }

  @override
  Future<void> time(
    String name,
    AsyncOrValueGetter<void> body, {
    CatalystProfilerTimelineTaskArguments? arguments,
  }) async {
    return body();
  }

  @override
  Future<T> timeWithResult<T>(
    String name,
    AsyncOrValueGetter<T> body, {
    CatalystProfilerTimelineTaskArguments? arguments,
  }) async {
    return body();
  }
}
