typedef ResponsiveBreakpointRange = ({int min, int max});

/// [ResponsiveBreakpointKey] is enum representing the responsive breakpoints.
///
/// The responsive breakpoints are used to define different screen sizes
/// for responsive design. The available keys are:
///   - `xs`: Extra small screens: 0 - 599
///   - `sm`: Small screens: 600 - 959
///   - `md`: Medium screens: 1240 - 1439
///   - `lg`: Large screens: 1440 - 2048
enum ResponsiveBreakpointKey {
  xs(range: (min: 0, max: 599)),
  sm(range: (min: 600, max: 1239)),
  md(range: (min: 1240, max: 1439)),
  lg(range: (min: 1440, max: 2048));

  final ResponsiveBreakpointRange range;

  const ResponsiveBreakpointKey({
    required this.range,
  });
}

extension ContainsExt on ResponsiveBreakpointRange {
  bool contains(double value) => value >= min && value <= max;
}
