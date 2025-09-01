import 'dart:async';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

abstract interface class CatalystProfiler {
  CatalystProfilerTimeline startTransaction(
    String name, {
    CatalystProfilerTimelineArguments? arguments,
  });

  Future<void> time(
    String name,
    FutureOr<void> Function() body, {
    CatalystProfilerTimelineArguments? arguments,
  });
}

abstract interface class CatalystProfilerTimeline {
  bool get finished;

  FutureOr<void> finish({
    CatalystProfilerTimelineFinishArguments? arguments,
  });

  CatalystProfilerTimelineTask startTask(
    String name, {
    CatalystProfilerTimelineTaskArguments? arguments,
  });
}

abstract interface class CatalystProfilerTimelineTask {
  FutureOr<void> finish({
    CatalystProfilerTimelineTaskFinishArguments? arguments,
  });

  CatalystProfilerTimelineTask startTask(
    String name, {
    CatalystProfilerTimelineTaskArguments? arguments,
  });
}
