import 'package:catalyst_voices/common/ext/preferences_ext.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

typedef TimezoneDateTimeTextFormatter = String Function(
  BuildContext context,
  DateTime dateTime,
);

/// Text widget aware of [TimezonePreferences] which will update automatically
/// whenever [UserSettings] changes.
///
/// This widget have to be places below [SessionCubit].
///
/// Example
///
/// ```dart
///   TimezoneDateTimeText(
///     DateTime.now(),
///     formatter: (context, dateTime) {
///       return DateFormatter.formatFullDateTime(dateTime);
///     },
///   ),
/// ```
///
/// Better way for using this widget is to create specialized version
/// of it like so
///
/// ```dart
///   class FullDateTimeText extends StatelessWidget {
///     final DateTime data;
///
///     const FullDateTimeText(
///         this.data, {
///           super.key,
///         });
///
///     @override
///     Widget build(BuildContext context) {
///       return TimezoneDateTimeText(
///         data,
///         formatter: (context, dateTime) {
///           return DateFormatter.formatFullDateTime(dateTime);
///         },
///       );
///     }
///   }
/// ```
///
/// and just use it.
///
/// ```dart
/// FullDateTimeText(DateTime.now());
/// ```
class TimezoneDateTimeText extends StatelessWidget {
  final DateTime data;
  final TimezoneDateTimeTextFormatter formatter;
  final bool showTimezone;
  final TextStyle? style;

  const TimezoneDateTimeText(
    this.data, {
    super.key,
    required this.formatter,
    this.showTimezone = true,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final timezone = context.select<SessionCubit?, TimezonePreferences>(
      (value) => value?.state.settings.timezone ?? TimezonePreferences.local,
    );
    final timezoneTheme = TimezoneDateTimeTextTheme.maybeOf(context);

    const states = <WidgetState>{};

    final effectiveData = switch (timezone) {
      TimezonePreferences.utc => data.toUtc(),
      TimezonePreferences.local => data.toLocal(),
    };
    final string = formatter(context, effectiveData);

    final timestampTextStyle =
        timezoneTheme?.timestampTextStyle ?? WidgetStatePropertyAll(textTheme.bodyMedium);
    final timezoneTextStyle =
        timezoneTheme?.timezoneTextStyle ?? WidgetStatePropertyAll(textTheme.labelSmall);

    final backgroundColor =
        timezoneTheme?.backgroundColor ?? WidgetStatePropertyAll(theme.colors.primary98);
    final foregroundColor =
        timezoneTheme?.foregroundColor ?? WidgetStatePropertyAll(theme.colors.textOnPrimaryLevel1);

    final effectiveBackgroundColor = backgroundColor.resolve(states);
    final effectiveForegroundColor = foregroundColor.resolve(states);

    final timestampStyle = (timestampTextStyle.resolve(states) ?? const TextStyle())
        .copyWith(color: effectiveForegroundColor);
    final timezoneStyle = (timezoneTextStyle.resolve(states) ?? const TextStyle())
        .copyWith(color: effectiveForegroundColor);

    return AffixDecorator(
      gap: showTimezone ? 6 : 0,
      suffix: showTimezone
          ? _TimezoneCard(
              timezone,
              style: timezoneStyle,
              backgroundColor: effectiveBackgroundColor,
            )
          : null,
      child: Text(
        key: const Key('TimezoneDateTimeText'),
        string,
        style: style != null ? timestampStyle.merge(style) : timestampStyle,
      ),
    );
  }
}

class _TimezoneCard extends StatelessWidget {
  final TimezonePreferences data;
  final TextStyle style;
  final Color backgroundColor;

  const _TimezoneCard(
    this.data, {
    required this.style,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(4),
      textStyle: style,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        child: Text(data.localizedName(context)),
      ),
    );
  }
}
