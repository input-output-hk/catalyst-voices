/// Priority levels for feature flag sources (higher = higher priority)
enum FeatureFlagSourceType {
  defaults(0),
  runtimeSource(1),
  config(2),
  dartDefine(3),
  userOverride(4);

  final int priority;

  const FeatureFlagSourceType(this.priority);
}
