/// Priority levels for feature flag sources (higher = higher priority)
enum FeatureFlagSourceType {
  defaults(priority: 0),
  runtimeSource(priority: 1),
  config(priority: 2),
  dartDefine(priority: 3),
  userOverride(priority: 4);

  final int priority;

  const FeatureFlagSourceType({required this.priority});
}
