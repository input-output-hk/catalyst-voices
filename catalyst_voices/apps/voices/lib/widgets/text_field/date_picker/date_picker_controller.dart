import 'dart:developer';

import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class DatePickerControllerState extends Equatable {
  final DateTime? selectedDate;
  final String? selectedTime;

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
      log(timePickerController.text);
      value = value.copyWith(
        selectedDate: Optional(calendarPickerController.selectedDate),
      );
    }
  }

  void _onTimePickerControllerChanged() {
    if (timePickerController.isValid) {
      log(timePickerController.text);
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

abstract class FieldDatePickerController extends TextEditingController {
  VoicesTextFieldValidationResult validate(String? value);

  bool get isValid => validate(text).status == VoicesTextFieldStatus.success;
}

class CalendarPickerController extends FieldDatePickerController {
  DateTime? get selectedDate => DateTime.tryParse(text);

  @override
  VoicesTextFieldValidationResult validate(String? value) {
    return const VoicesTextFieldValidationResult(
      status: VoicesTextFieldStatus.success,
    );
  }
}

class TimePickerController extends FieldDatePickerController {
  @override
  VoicesTextFieldValidationResult validate(String? value) {
    return const VoicesTextFieldValidationResult(
      status: VoicesTextFieldStatus.success,
    );
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
