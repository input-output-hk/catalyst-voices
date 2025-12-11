import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

abstract interface class CatalystProfiler {
  const factory CatalystProfiler.console() = CatalystConsoleProfiler;

  factory CatalystProfiler.developer(CatalystDeveloperProfilerConfig config) =
      CatalystDeveloperProfiler.fromConfig;

  const factory CatalystProfiler.noop() = CatalystNoopProfiler;

  const factory CatalystProfiler.sentry() = CatalystSentryProfiler;

  CatalystProfilerTimeline startTransaction(
    String name, {
    CatalystProfilerTimelineArguments? arguments,
  });

  Future<void> time(
    String name,
    AsyncOrValueGetter<void> body, {
    CatalystProfilerTimelineArguments? arguments,
  });

  Future<T> timeWithResult<T>(
    String name,
    AsyncOrValueGetter<T> body, {
    CatalystProfilerTimelineArguments? arguments,
    bool debounce,
  });
}

abstract interface class CatalystProfilerTimeline {
  bool get finished;

  Future<void> finish({
    CatalystProfilerTimelineFinishArguments? arguments,
  });

  CatalystProfilerTimelineTask startTask(
    String name, {
    CatalystProfilerTimelineTaskArguments? arguments,
  });

  Future<void> time(
    String name,
    AsyncOrValueGetter<void> body, {
    CatalystProfilerTimelineTaskArguments? arguments,
  });

  Future<T> timeWithResult<T>(
    String name,
    AsyncOrValueGetter<T> body, {
    CatalystProfilerTimelineTaskArguments? arguments,
  });
}

abstract interface class CatalystProfilerTimelineTask {
  Future<void> finish({
    CatalystProfilerTimelineTaskFinishArguments? arguments,
  });

  CatalystProfilerTimelineTask startTask(
    String name, {
    CatalystProfilerTimelineTaskArguments? arguments,
  });
}
