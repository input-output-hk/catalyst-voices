import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/text_field/date_time_picker/field_date_picker_controller.dart';
import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

part 'base_picker.dart';
part 'pickers/voices_calendar_picker.dart';
part 'pickers/voices_time_picker.dart';

enum DateTimePickerType { date, time }

final GlobalKey calendarKey = GlobalKey();
final GlobalKey timeKey = GlobalKey();

class VoicesDateTimeController extends ValueNotifier<DateTime?> {
  DateTime? date;
  DateTime? time;

  VoicesDateTimeController([super.value]);

  DateTime? get _value {
    if (date != null && time != null) {
      return DateTime(
        date!.year,
        date!.month,
        date!.day,
        time!.hour,
        time!.minute,
      );
    }
    return null;
  }

  bool get isValid => _value != null;

  void updateDate(DateTime? date) {
    this.date = date;
    value = _value;
  }

  void updateTimeOfDate(DateTime? time) {
    this.time = time;
    value = _value;
  }
}

class VoicesDateTimePicker extends StatefulWidget {
  final VoicesDateTimeController controller;
  final String timezone;
  const VoicesDateTimePicker({
    super.key,
    required this.controller,
    required this.timezone,
  });

  @override
  State<VoicesDateTimePicker> createState() => _VoicesDateTimePickerState();
}

class _VoicesDateTimePickerState extends State<VoicesDateTimePicker> {
  late final CalendarPickerController _dateController;
  late final TimePickerController _timeController;

  @override
  void initState() {
    super.initState();
    _dateController = CalendarPickerController()..addListener(_dateListener);
    _timeController = TimePickerController()..addListener(_timeListener);
  }

  void _dateListener() {
    widget.controller.updateDate(_dateController.selectedValue);
  }

  void _timeListener() {
    widget.controller.updateTimeOfDate(_timeController.selectedValue);
  }

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
    _timeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CalendarFieldPicker(
          controller: _dateController,
        ),
        TimeFieldPicker(
          controller: _timeController,
          timeZone: widget.timezone,
        ),
      ],
    );
  }
}
