import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_localization/generated/catalyst_voices_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

sealed class FieldDatePickerController<T> extends TextEditingController {
  abstract final String pattern;

  bool get isValid => validate(text) == DatePickerValidationStatus.success;
  T get selectedValue;

  DatePickerValidationStatus validate(String? value);

  void setValue(T newValue);
}

final class CalendarPickerController
    extends FieldDatePickerController<DateTime?> {
  @override
  DateTime? get selectedValue {
    if (text.isEmpty) return null;

    final parts = text.split('/');
    if (parts.length != 3) return null;

    try {
      final reformatted = '${parts[2]}-${parts[1]}-${parts[0]}';
      final formatDt = DateTime.parse(reformatted);

      if (formatDt.month < 1 || formatDt.month > 12) return null;
      if (formatDt.day < 1 || formatDt.day > 31) return null;
      if (formatDt.year < 1900 || formatDt.year > 2100) return null;

      return formatDt;
    } catch (e) {
      return null;
    }
  }

  @override
  String get pattern => 'dd/MM/yyyy';

  @override
  DatePickerValidationStatus validate(String? value) {
    final today = DateTime.now();
    final maxDate = DateTime(today.year + 1, today.month, today.day);

    if (value == null || value == '') {
      return DatePickerValidationStatus.success;
    }

    if (value.length != 10) return DatePickerValidationStatus.dateFormatError;

    final dateRegex = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$');
    if (!dateRegex.hasMatch(value)) {
      return DatePickerValidationStatus.dateFormatError;
    }

    final parts = value.split('/');
    final reformatted = '${parts[2]}-${parts[1]}-${parts[0]}';

    // Need this because DateTime.parse accepts out-of-range component values
    // and interprets them as overflows into the next larger component
    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);
    final formatDt = DateTime.parse(reformatted);
    if (month < 1 || month > 12) {
      return DatePickerValidationStatus.dateFormatError;
    }
    if (day < 1 || day > 31) {
      return DatePickerValidationStatus.daysInMonthError;
    }

    final daysInMonth = DateTime(year, month + 1, 0).day;
    if (day > daysInMonth) {
      return DatePickerValidationStatus.daysInMonthError;
    }
    if (formatDt.isBefore(today.subtract(const Duration(days: 1))) ||
        formatDt.isAfter(maxDate)) {
      return DatePickerValidationStatus.dateRangeError;
    }

    return DatePickerValidationStatus.success;
  }

  @override
  void setValue(DateTime? newValue) {
    if (newValue == null) return;
    final newT = newValue;
    final formatter = DateFormat(pattern);
    value = TextEditingValue(text: formatter.format(newT));
  }
}

final class TimePickerController extends FieldDatePickerController<DateTime?> {
  @override
  DateTime? get selectedValue {
    if (text.isEmpty) return null;
    if (!isValid) return null;
    try {
      final parts = text.split(':');
      return DateTime(
        0,
        0,
        0,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  String get pattern => 'HH:MM';

  @override
  DatePickerValidationStatus validate(String? value) {
    if (value == null || value == '') {
      return DatePickerValidationStatus.success;
    }
    final pattern = RegExp(r'^(0?[0-9]|1[0-9]|2[0-3]):([0-5][0-9])$');
    if (!pattern.hasMatch(value)) {
      return DatePickerValidationStatus.timeFormatError;
    }

    return DatePickerValidationStatus.success;
  }

  @override
  void setValue(DateTime? newValue) {
    if (newValue == null) return;
    value = TextEditingValue(
      text:
          // ignore: lines_longer_than_80_chars
          '${newValue.hour.toString().padLeft(2, '0')}:${newValue.minute.toString().padLeft(2, '0')}',
    );
  }
}

enum DatePickerValidationStatus {
  success,
  dateFormatError,
  timeFormatError,
  dateRangeError,
  daysInMonthError;

  VoicesTextFieldValidationResult message(
    VoicesLocalizations l10n,
    String pattern,
  ) =>
      switch (this) {
        DatePickerValidationStatus.success =>
          const VoicesTextFieldValidationResult(
            status: VoicesTextFieldStatus.success,
          ),
        DatePickerValidationStatus.dateFormatError =>
          VoicesTextFieldValidationResult(
            status: VoicesTextFieldStatus.error,
            errorMessage: '${l10n.format}: ${pattern.toUpperCase()}',
          ),
        DatePickerValidationStatus.timeFormatError =>
          VoicesTextFieldValidationResult(
            status: VoicesTextFieldStatus.error,
            errorMessage: '${l10n.format}: $pattern',
          ),
        DatePickerValidationStatus.dateRangeError =>
          VoicesTextFieldValidationResult(
            status: VoicesTextFieldStatus.error,
            errorMessage: l10n.datePickerDateRangeError,
          ),
        DatePickerValidationStatus.daysInMonthError =>
          VoicesTextFieldValidationResult(
            status: VoicesTextFieldStatus.error,
            errorMessage: l10n.datePickerDaysInMonthError,
          ),
      };
}
