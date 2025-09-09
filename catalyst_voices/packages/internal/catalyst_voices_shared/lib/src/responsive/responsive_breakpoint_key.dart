typedef ResponsiveBreakpointRange = ({int min, int max});

/// [ResponsiveBreakpointKey] is enum representing the responsive breakpoints.
///
/// The responsive breakpoints are used to define different screen sizes
/// for responsive design. The available keys are:
///   - `xs`: Extra small screens: 0 - 599
///   - `sm`: Small screens: 600 - 959
///   - `md`: Medium screens: 1240 - 1439
///   - `lg`: Large screens: 1440 - 2048
///   - `other`: Other screen sizes not covered by the above keys.
enum ResponsiveBreakpointKey {
  xs(range: (min: 0, max: 599)),
  sm(range: (min: 600, max: 1239)),
  md(range: (min: 1240, max: 1439)),
  lg(range: (min: 1440, max: 2048)),
  // TODO remove
  other(range: (min: -1, max: -1));

  final ResponsiveBreakpointRange range;

  const ResponsiveBreakpointKey({
    required this.range,
  });
}

extension ConstainsExt on ResponsiveBreakpointRange {
  bool contains(double value) => value >= min && value <= max;
}
