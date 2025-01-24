import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef DateTimeFormatBuilder = String Function(
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
///     formatBuilder: (context, dateTime) {
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
///         formatBuilder: (context, dateTime) {
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
  final DateTimeFormatBuilder formatBuilder;
  final TextStyle? style;

  const TimezoneDateTimeText(
    this.data, {
    super.key,
    required this.formatBuilder,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final timezone = context.select<SessionCubit, TimezonePreferences>(
      (value) => value.state.settings.timezone,
    );

    final effectiveData = switch (timezone) {
      TimezonePreferences.utc => data.toUtc(),
      TimezonePreferences.local => data.toLocal(),
    };
    final string = formatBuilder(context, effectiveData);

    final baseStyle = (textTheme.bodyMedium ?? const TextStyle()).copyWith(
      color: theme.colors.textOnPrimaryLevel1,
    );

    final style = this.style ?? const TextStyle();
    final effectiveStyle = style.merge(baseStyle);

    return AffixDecorator(
      gap: 6,
      suffix: _TimezoneCard(timezone),
      child: Text(
        string,
        style: effectiveStyle,
      ),
    );
  }
}

class _TimezoneCard extends StatelessWidget {
  final TimezonePreferences data;

  const _TimezoneCard(this.data);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // TODO(damian-molinski): update this color from schema.
    const backgroundColor = Color(0xFFE8ECFD);
    final foregroundColor = theme.colors.textOnPrimaryLevel1;

    final style = (textTheme.labelSmall ?? const TextStyle()).copyWith(
      color: foregroundColor,
    );

    final text = switch (data) {
      TimezonePreferences.utc => 'UTC',
      TimezonePreferences.local => context.l10n.local,
    };

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(4),
      textStyle: style,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        child: Text(text),
      ),
    );
  }
}
