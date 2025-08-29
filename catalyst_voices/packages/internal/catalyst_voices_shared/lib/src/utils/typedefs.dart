import 'package:flutter/widgets.dart';

/// Builds a [Widget] when given a concrete value of a [data].
typedef DataWidgetBuilder<T> = Widget Function(BuildContext context, T data);

/// Returns [R] out of given [data].
typedef ValueResolver<T, R> = R Function(T data);
