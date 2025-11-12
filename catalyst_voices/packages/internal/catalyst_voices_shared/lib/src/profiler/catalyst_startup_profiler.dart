import 'dart:async';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';

class CatalystStartupProfiler extends CatalystBaseProfiler {
  CatalystStartupProfiler(super.delegate);

  void appConfig({
    required DateRange fromTo,
  }) {
    assert(ongoing, 'Startup profiler already finished');

    final startArgs = CatalystProfilerTimelineTaskArguments(
      description: 'How long it takes for app config resolve',
      startTimestamp: fromTo.from,
    );
    final endArgs = CatalystProfilerTimelineTaskFinishArguments(endTimestamp: fromTo.to);

    final task = timeline!.startTask('config', arguments: startArgs);
    unawaited(task.finish(arguments: endArgs));
  }

  Future<void> awaitingFonts({
    required AsyncValueGetter<void> body,
  }) async {
    assert(ongoing, 'Startup profiler already finished');

    return timeline!.time('pending_fonts', body);
  }

  Future<void> documentsSync({
    required AsyncValueGetter<void> body,
  }) async {
    assert(ongoing, 'Startup profiler already finished');

    return timeline!.time('startup_documents_sync', body);
  }

  Future<void> imagesCache({
    required AsyncValueGetter<void> body,
  }) {
    assert(ongoing, 'Startup profiler already finished');

    return timeline!.time('image_assets_precache', body);
  }

  @override
  void start({
    required DateTime at,
  }) {
    assert(!ongoing, 'Startup profiler already initialized');

    timeline = delegate.startTransaction(
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

    return timeline!.time('video_precache', body);
  }
}
