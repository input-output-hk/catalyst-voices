import 'package:flutter/widgets.dart';

class DynamicPadding extends StatelessWidget {
  final Widget child;
  final Map<String, EdgeInsets?> _paddings;

  DynamicPadding({
    super.key,
    required this.child,
    EdgeInsets small = const EdgeInsets.all(8),
    EdgeInsets medium = const EdgeInsets.all(12),
    EdgeInsets large = const EdgeInsets.all(16),
    EdgeInsets other = const EdgeInsets.all(8),
  }) : _paddings = {
    'small': small,
    'medium': medium,
    'large': large,
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
    'small': (min: 0, max: 600),
    'medium': (min: 601, max: 1024),
    'large': (min: 1025, max: 2048),
  };
}
