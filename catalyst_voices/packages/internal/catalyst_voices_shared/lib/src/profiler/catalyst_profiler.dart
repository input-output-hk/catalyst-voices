import 'dart:async';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

abstract interface class CatalystProfiler {
  CatalystProfilerTimeline startTransaction(
    String name, {
    CatalystProfilerTimelineArguments? arguments,
  });

  Future<void> time(
    String name,
    AsyncOrValueGetter<void> body, {
    CatalystProfilerTimelineArguments? arguments,
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
