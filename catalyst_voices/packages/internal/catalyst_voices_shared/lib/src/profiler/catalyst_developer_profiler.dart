import 'dart:async';
import 'dart:developer' as developer;

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/src/profiler/profiler.dart';
import 'package:catalyst_voices_shared/src/utils/typedefs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart' as rendering;
import 'package:flutter/widgets.dart' as widgets;

final class CatalystDeveloperProfiler implements CatalystProfiler {
  final bool debugProfileBuildsEnabled;
  final bool debugProfileBuildsEnabledUserWidgets;
  final bool debugProfileLayoutsEnabled;
  final bool debugProfilePaintsEnabled;

  CatalystDeveloperProfiler({
    required this.debugProfileBuildsEnabled,
    required this.debugProfileBuildsEnabledUserWidgets,
    required this.debugProfileLayoutsEnabled,
    required this.debugProfilePaintsEnabled,
  }) {
    widgets.debugProfileBuildsEnabled = debugProfileBuildsEnabled;
    widgets.debugProfileBuildsEnabledUserWidgets = debugProfileBuildsEnabledUserWidgets;

    rendering.debugProfileLayoutsEnabled = debugProfileLayoutsEnabled;
    rendering.debugProfilePaintsEnabled = debugProfilePaintsEnabled;
  }

  factory CatalystDeveloperProfiler.disableAll() => CatalystDeveloperProfiler(
    debugProfileBuildsEnabled: false,
    debugProfileBuildsEnabledUserWidgets: false,
    debugProfileLayoutsEnabled: false,
    debugProfilePaintsEnabled: false,
  );

  factory CatalystDeveloperProfiler.enableAll() => CatalystDeveloperProfiler(
    debugProfileBuildsEnabled: true,
    debugProfileBuildsEnabledUserWidgets: true,
    debugProfileLayoutsEnabled: true,
    debugProfilePaintsEnabled: true,
  );

  factory CatalystDeveloperProfiler.fromConfig(CatalystDeveloperProfilerConfig config) {
    debugPrint('CatalystDeveloperProfiler configuration: $config');
    if (!kProfileMode) {
      debugPrint('CatalystDeveloperProfiler is enabled only in Profile mode.');

      return CatalystDeveloperProfiler.disableAll();
    } else if (config.debugProfileDeveloperProfilerEnableAll) {
      return CatalystDeveloperProfiler.enableAll();
    }
    return CatalystDeveloperProfiler(
      debugProfileBuildsEnabled: config.debugProfileBuildsEnabledConfig,
      debugProfileBuildsEnabledUserWidgets: config.debugProfileBuildsEnabledUserWidgetsConfig,
      debugProfileLayoutsEnabled: config.debugProfileLayoutsEnabledConfig,
      debugProfilePaintsEnabled: config.debugProfilePaintsEnabledConfig,
    );
  }

  @override
  CatalystProfilerTimeline startTransaction(
    String name, {
    CatalystProfilerTimelineArguments? arguments,
  }) {
    final task = developer.TimelineTask()
      ..start(
        name,
        arguments: arguments?.toMap(),
      );

    return _DeveloperTimeline(task);
  }

  @override
  Future<void> time(
    String name,
    AsyncOrValueGetter<void> body, {
    CatalystProfilerTimelineArguments? arguments,
  }) async {
    final transaction = startTransaction(name, arguments: arguments);
    final finishArgs = CatalystProfilerTimelineFinishArguments();

    try {
      await body();
      finishArgs.status = 'completed';
    } catch (error) {
      finishArgs
        ..throwable = error
        ..status = 'failed';
      rethrow;
    } finally {
      await transaction.finish(arguments: finishArgs);
    }
  }

  @override
  Future<T> timeWithResult<T>(
    String name,
    AsyncOrValueGetter<T> body, {
    CatalystProfilerTimelineArguments? arguments,
    bool debounce = false,
  }) async {
    final transaction = startTransaction(name, arguments: arguments);
    final finishArgs = CatalystProfilerTimelineFinishArguments();

    try {
      final result = await body();
      finishArgs.status = 'completed';
      return result;
    } catch (error) {
      finishArgs
        ..throwable = error
        ..status = 'failed';
      rethrow;
    } finally {
      await transaction.finish(arguments: finishArgs);
    }
  }
}

final class _DeveloperTask implements CatalystProfilerTimelineTask {
  final developer.TimelineTask _task;

  _DeveloperTask(this._task);

  @override
  Future<void> finish({
    CatalystProfilerTimelineTaskFinishArguments? arguments,
  }) async {
    _task.finish(arguments: arguments?.toMap());
  }

  @override
  CatalystProfilerTimelineTask startTask(
    String name, {
    CatalystProfilerTimelineTaskArguments? arguments,
  }) {
    final childTask = developer.TimelineTask(parent: _task)
      ..start(
        name,
        arguments: arguments?.toMap(),
      );

    return _DeveloperTask(childTask);
  }
}

final class _DeveloperTimeline implements CatalystProfilerTimeline {
  final developer.TimelineTask _task;
  bool _finished = false;

  _DeveloperTimeline(this._task);

  @override
  bool get finished => _finished;

  @override
  Future<void> finish({
    CatalystProfilerTimelineFinishArguments? arguments,
  }) async {
    _task.finish(arguments: arguments?.toMap());
    _finished = true;
  }

  @override
  CatalystProfilerTimelineTask startTask(
    String name, {
    CatalystProfilerTimelineTaskArguments? arguments,
  }) {
    final childTask = developer.TimelineTask(parent: _task)
      ..start(
        name,
        arguments: arguments?.toMap(),
      );

    return _DeveloperTask(childTask);
  }

  @override
  Future<void> time(
    String name,
    AsyncOrValueGetter<void> body, {
    CatalystProfilerTimelineTaskArguments? arguments,
  }) async {
    final task = startTask(name, arguments: arguments);
    final finishArgs = CatalystProfilerTimelineTaskFinishArguments();

    try {
      await body();
      finishArgs.status = 'completed';
    } catch (error) {
      finishArgs
        ..throwable = error
        ..status = 'failed';
      rethrow;
    } finally {
      await task.finish(arguments: finishArgs);
    }
  }

  @override
  Future<T> timeWithResult<T>(
    String name,
    AsyncOrValueGetter<T> body, {
    CatalystProfilerTimelineTaskArguments? arguments,
  }) async {
    final task = startTask(name, arguments: arguments);
    final finishArgs = CatalystProfilerTimelineTaskFinishArguments();

    try {
      final result = await body();
      finishArgs.status = 'completed';
      return result;
    } catch (error) {
      finishArgs
        ..throwable = error
        ..status = 'failed';
      rethrow;
    } finally {
      await task.finish(arguments: finishArgs);
    }
  }
}
