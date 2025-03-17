import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class TimezoneDateTimeTextTheme extends InheritedTheme {
  final TimezoneDateTimeTextThemeData data;

  const TimezoneDateTimeTextTheme({
    super.key,
    required this.data,
    required super.child,
  });

  @override
  bool updateShouldNotify(TimezoneDateTimeTextTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return TimezoneDateTimeTextTheme(data: data, child: child);
  }

  static TimezoneDateTimeTextThemeData? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TimezoneDateTimeTextTheme>()
        ?.data;
  }
}

final class TimezoneDateTimeTextThemeData extends Equatable {
  final WidgetStateProperty<TextStyle?>? timestampTextStyle;
  final WidgetStateProperty<TextStyle?>? timezoneTextStyle;
  final WidgetStateProperty<Color>? backgroundColor;
  final WidgetStateProperty<Color>? foregroundColor;

  const TimezoneDateTimeTextThemeData({
    this.timestampTextStyle,
    this.timezoneTextStyle,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  List<Object?> get props => [
        timestampTextStyle,
        timezoneTextStyle,
        backgroundColor,
        foregroundColor,
      ];
}
