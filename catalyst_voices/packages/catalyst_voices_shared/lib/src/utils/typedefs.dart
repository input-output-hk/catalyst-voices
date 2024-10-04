import 'package:catalyst_voices_shared/src/responsive/responsive_builder.dart';
import 'package:flutter/widgets.dart';

/// Builds a [Widget] when given a concrete value of a [ResponsiveBuilder].
///
/// See also:
///
///  * [ResponsiveBuilder], a widget which invokes this builder each time
///    a screenSize changes value.
typedef DataWidgetBuilder<T> = Widget Function(BuildContext context, T data);
