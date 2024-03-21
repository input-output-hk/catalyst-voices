import 'package:flutter/widgets.dart';

// A [DynamicPadding] is a StatelessWidget that applies a padding based on the
// current screen size.
//
// The widget wraps its child into a Padding and it applies the specified
// EdgeInsets for each screen size.
//
// The size considered is the screen width and it's extracted from MediaQuery.
//
// The possible arguments are [xs], [sm], [md], [lg], [other] following the 
// Material design standards for naming and breakpoint sizes.
// Each screen size has a default value to simplify widget usage.
//
// Example usage:
// 
// ```dart
// DynamicPadding(
//   xs: const EdgeInsets.all(4.0),
//   sm: const EdgeInsets.all(6.0),
//   md: const EdgeInsets.only(top: 6.0),
//   lg: const EdgeInsets.symmetric(vertical: 15.0),
//   child: Text('This is an example text with dynamic padding.')
// );
// ```

class DynamicPadding extends StatelessWidget {
  final Widget child;
  final Map<String, EdgeInsets> _paddings;

  DynamicPadding({
    super.key,
    required this.child,
    EdgeInsets xs = const EdgeInsets.all(4),
    EdgeInsets sm = const EdgeInsets.all(8),
    EdgeInsets md = const EdgeInsets.all(12),
    EdgeInsets lg = const EdgeInsets.all(16),
    EdgeInsets other = const EdgeInsets.all(8),
  }) : _paddings = {
    'xs': xs,
    'sm': sm,
    'md': md,
    'lg': lg,
    'other': other,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _selectPadding(context),
      child: child,
    );
  }

  EdgeInsets _selectPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final currentPaddingKey = _screenSizes.entries
      .firstWhere(
        (entry) => (
          screenWidth >= entry.value.min && screenWidth <= entry.value.max
        ),
        orElse: () => const MapEntry('other', (min: 0, max: 0)),
      )
      .key;
    return _paddings[currentPaddingKey]!;
  }

  final Map<String, ({int min, int max})> _screenSizes = {
    'xs': (min: 0, max: 599),
    'sm': (min: 600, max: 1239),
    'md': (min: 1240, max: 1439),
    'lg': (min: 1440, max: 2048),
  };
}
