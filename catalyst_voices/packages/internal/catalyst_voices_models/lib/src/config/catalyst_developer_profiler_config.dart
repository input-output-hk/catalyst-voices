import 'package:equatable/equatable.dart';

final class CatalystDeveloperProfilerConfig extends Equatable {
  const CatalystDeveloperProfilerConfig();

  bool get debugProfileBuildsEnabledConfig =>
      const bool.fromEnvironment('DEBUG_PROFILE_BUILDS_ENABLED');

  bool get debugProfileBuildsEnabledUserWidgetsConfig =>
      const bool.fromEnvironment('DEBUG_PROFILE_BUILDS_ENABLED_USER_WIDGETS');

  bool get debugProfileDeveloperProfilerEnableAll =>
      const bool.fromEnvironment('DEBUG_PROFILE_DEVELOPER_PROFILER_ENABLE_ALL');

  bool get debugProfileLayoutsEnabledConfig =>
      const bool.fromEnvironment('DEBUG_PROFILE_LAYOUTS_ENABLED');

  bool get debugProfilePaintsEnabledConfig =>
      const bool.fromEnvironment('DEBUG_PROFILE_PAINTS_ENABLED');

  bool get console => const bool.fromEnvironment('CONSOLE_PROFILE');

  @override
  List<Object?> get props => [];

  @override
  String toString() {
    return 'CatalystDeveloperProfilerConfig{'
        'debugProfileBuildsEnabledConfig: $debugProfileBuildsEnabledConfig, '
        'debugProfileBuildsEnabledUserWidgetsConfig: $debugProfileBuildsEnabledUserWidgetsConfig, '
        'debugProfileDeveloperProfilerEnableAll: $debugProfileDeveloperProfilerEnableAll, '
        'debugProfileLayoutsEnabledConfig: $debugProfileLayoutsEnabledConfig, '
        'debugProfilePaintsEnabledConfig: $debugProfilePaintsEnabledConfig, '
        'console: $console'
        '}';
  }
}
