import 'dart:async';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';

/// Base class for Catalyst profilers that provides common functionality
/// for managing profiling timelines.
///
/// Subclasses should extend this class to implement specific profiling
/// scenarios (e.g., startup profiling, runtime profiling).
abstract class CatalystBaseProfiler {
  /// The underlying profiler delegate that handles the actual profiling.
  @protected
  final CatalystProfiler delegate;

  /// The current profiling timeline, if one is active.
  @protected
  CatalystProfilerTimeline? timeline;

  CatalystBaseProfiler(this.delegate);

  /// Whether a profiling session is currently ongoing.
  bool get ongoing => !(timeline?.finished ?? true);

  /// Finishes the current profiling session.
  void finish() {
    assert(ongoing, 'Profiler already finished');

    unawaited(timeline!.finish(arguments: CatalystProfilerTimelineFinishArguments()));
  }

  void start({required DateTime at});
}
