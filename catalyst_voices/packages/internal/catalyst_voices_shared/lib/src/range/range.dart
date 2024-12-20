class Range<T extends num> {
  final T min;
  final T max;

  const Range({required this.min, required this.max});

  static Range<int>? createIntRange({int? min, int? max}) {
    if (min == null || max == null) {
      return null;
    }
    return Range(min: min, max: max);
  }
}
