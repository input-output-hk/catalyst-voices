import 'package:flutter/widgets.dart';

class DynamicPadding extends StatelessWidget {
  final Widget child;
  final Map<String, EdgeInsets?> _paddings;

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
