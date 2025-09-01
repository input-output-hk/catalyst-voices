import 'dart:async';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';

class CatalystStartupProfiler {
  final CatalystProfiler _delegate;

  CatalystProfilerTimeline? _timeline;

  CatalystStartupProfiler(this._delegate);

  bool get ongoing => !(_timeline?.finished ?? true);

  void appConfig({
    required DateRange fromTo,
  }) {
    assert(ongoing, 'Startup profiler already finished');

    final startArgs = CatalystProfilerTimelineTaskArguments(
      description: 'How long it takes for app config resolve',
      startTimestamp: fromTo.from,
    );
    final endArgs = CatalystProfilerTimelineTaskFinishArguments(endTimestamp: fromTo.to);

    final task = _timeline!.startTask('config', arguments: startArgs);
    unawaited(task.finish(arguments: endArgs));
  }

  Future<void> documentsSync({
    required AsyncValueGetter<void> body,
  }) async {
    assert(ongoing, 'Startup profiler already finished');

    final task = _timeline!.startTask('documents_sync');
    final args = CatalystProfilerTimelineTaskFinishArguments();

    try {
      await body();
      args.status = 'completed';
    } catch (_, _) {
      args.status = 'failed';
    } finally {
      unawaited(task.finish());
    }
  }

  void finish() {
    assert(ongoing, 'Startup profiler already finished');

    unawaited(_timeline!.finish(arguments: CatalystProfilerTimelineFinishArguments()));
  }

  Future<void> imagesCache({
    required AsyncValueGetter<void> body,
  }) async {
    assert(ongoing, 'Startup profiler already finished');

    final task = _timeline!.startTask('image_assets_precache');
    final args = CatalystProfilerTimelineTaskFinishArguments();

    try {
      await body();
      args.status = 'completed';
    } catch (_, _) {
      args.status = 'failed';
    } finally {
      unawaited(task.finish());
    }
  }

  void start({
    required DateTime at,
  }) {
    assert(!ongoing, 'Startup profiler already initialized');

    _timeline = _delegate.startTransaction(
      'Startup',
      arguments: CatalystProfilerTimelineArguments(
        operation: 'initialisation',
        description:
            'Measuring how long it takes from flutter code '
            'execution to Application widget beaning ready.',
        startTimestamp: at,
      ),
    );
  }

  Future<void> videoCache({
    required AsyncValueGetter<void> body,
  }) async {
    assert(ongoing, 'Startup profiler already finished');

    final task = _timeline!.startTask('video_precache');
    final args = CatalystProfilerTimelineTaskFinishArguments();

    try {
      await body();
      args.status = 'completed';
    } catch (_, _) {
      args.status = 'failed';
    } finally {
      unawaited(task.finish());
    }
  }
}
