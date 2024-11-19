import 'package:catalyst_voices/widgets/text_field/date_picker/date_picker_controller.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

part 'base_picker.dart';
part 'voices_calendar_picker.dart';
part 'voices_time_picker.dart';

enum DateTimePickerType { date, time }

final GlobalKey calendarKey = GlobalKey();
final GlobalKey timeKey = GlobalKey();

class VoicesDatePicker extends StatefulWidget {
  final DatePickerController controller;
  final String timeZone;
  const VoicesDatePicker({
    super.key,
    required this.controller,
    required this.timeZone,
  });

  @override
  State<VoicesDatePicker> createState() => _VoicesDatePickerState();
}

class _VoicesDatePickerState extends State<VoicesDatePicker> {
  final CalendarPickerController _calendarPickerController =
      CalendarPickerController();
  final TimePickerController _timePickerController = TimePickerController();

  @override
  void dispose() {
    super.dispose();
    _calendarPickerController.dispose();
    _timePickerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CalendarFieldPicker(
          key: calendarKey,
          controller: _calendarPickerController,
        ),
        TimeFieldPicker(
          key: timeKey,
          controller: _timePickerController,
          timeZone: widget.timeZone,
        ),
      ],
    );
  }
}
