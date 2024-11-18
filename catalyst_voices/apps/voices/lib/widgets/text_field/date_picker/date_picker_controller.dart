import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_localization/generated/catalyst_voices_localizations.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum DatePickerValidationStatus {
  success,
  dateFormatError,
  timeFormatError,
  dateRangeError,
  daysInMonthError
}

extension DatePickerValidationStatusExt on DatePickerValidationStatus {
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

final class DatePickerControllerState extends Equatable {
  final DateTime? selectedDate;
  final String? selectedTime;

  bool get isValid => selectedDate != null && selectedTime != null;

  factory DatePickerControllerState({
    DateTime? selectedDate,
    String? selectedTime,
  }) {
    return DatePickerControllerState._(
      selectedDate: selectedDate,
      selectedTime: selectedTime,
    );
  }

  const DatePickerControllerState._({
    this.selectedDate,
    this.selectedTime,
  });

  DatePickerControllerState copyWith({
    Optional<DateTime>? selectedDate,
    Optional<String>? selectedTime,
  }) {
    return DatePickerControllerState(
      selectedDate: selectedDate.dataOr(this.selectedDate),
      selectedTime: selectedTime.dataOr(this.selectedTime),
    );
  }

  @override
  List<Object?> get props => [
        selectedDate,
        selectedTime,
      ];
}

final class DatePickerController
    extends ValueNotifier<DatePickerControllerState> {
  CalendarPickerController calendarPickerController =
      CalendarPickerController();
  TimePickerController timePickerController = TimePickerController();

  DatePickerController([super.value = const DatePickerControllerState._()]) {
    calendarPickerController.addListener(_onCalendarPickerControllerChanged);
    timePickerController.addListener(_onTimePickerControllerChanged);
  }

  void _onCalendarPickerControllerChanged() {
    if (calendarPickerController.isValid) {
      value = value.copyWith(
        selectedDate: Optional(calendarPickerController.selectedValue),
      );
    }
  }

  void _onTimePickerControllerChanged() {
    if (timePickerController.isValid) {
      value = value.copyWith(
        selectedTime: Optional(timePickerController.text),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    calendarPickerController.removeListener(_onCalendarPickerControllerChanged);
    timePickerController.removeListener(_onTimePickerControllerChanged);
    calendarPickerController.dispose();
    timePickerController.dispose();
  }
}

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
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      if (month < 1 || month > 12) return null;
      if (day < 1 || day > 31) return null;
      if (year < 1900 || year > 2100) return null;

      return DateTime(year, month, day);
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
    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);

    if (month < 1 || month > 12) {
      return DatePickerValidationStatus.dateFormatError;
    }
    if (day < 1 || day > 31) return DatePickerValidationStatus.daysInMonthError;

    final inputDate = DateTime(year, month, day);

    if (inputDate.isBefore(today.subtract(const Duration(days: 1))) ||
        inputDate.isAfter(maxDate)) {
      return DatePickerValidationStatus.dateRangeError;
    }

    final daysInMonth = DateTime(year, month + 1, 0).day;
    if (day > daysInMonth) {
      return DatePickerValidationStatus.daysInMonthError;
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

final class TimePickerController extends FieldDatePickerController<String?> {
  @override
  String get pattern => 'HH:MM';

  @override
  String? get selectedValue => text;

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
  void setValue(String? newValue) {
    value = TextEditingValue(text: newValue.toString());
  }
}

final class DatePickerControllerScope extends InheritedWidget {
  final DatePickerController controller;

  const DatePickerControllerScope({
    super.key,
    required this.controller,
    required super.child,
  });

  static DatePickerController of(BuildContext context) {
    final controller = context
        .dependOnInheritedWidgetOfExactType<DatePickerControllerScope>()
        ?.controller;

    assert(
      controller != null,
      'Unable to find DatePickerControllerScope in widget tree',
    );

    return controller!;
  }

  @override
  bool updateShouldNotify(covariant DatePickerControllerScope oldWidget) {
    return controller != oldWidget.controller;
  }
}
