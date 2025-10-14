import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart' as rendering;
import 'package:flutter/widgets.dart' as widgets;

interface class CatalystDeveloperProfiler {
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
}
