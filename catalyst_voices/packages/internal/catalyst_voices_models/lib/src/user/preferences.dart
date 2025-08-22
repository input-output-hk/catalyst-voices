import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

enum ThemePreferences { dark, light }

enum TimezonePreferences {
  utc,
  local;

  DateTime applyTo(DateTime dateTime) {
    return switch (this) {
      TimezonePreferences.utc => dateTime.toUtc(),
      TimezonePreferences.local => dateTime.toLocal(),
    };
  }

  DateRange applyToRange(DateRange dateRange) {
    return dateRange.copyWith(
      from: Optional(dateRange.from.withTimezone(this)),
      to: Optional(dateRange.to.withTimezone(this)),
    );
  }
}

extension on DateTime? {
  DateTime? withTimezone(TimezonePreferences timezone) {
    final instance = this;
    if (instance == null) {
      return null;
    }
    return timezone.applyTo(instance);
  }
}
