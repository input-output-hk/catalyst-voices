import 'package:catalyst_voices/widgets/text_field/date_picker/date_picker_controller.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

part 'base_picker.dart';
part 'voices_calendar_picker.dart';
part 'voices_time_picker.dart';

enum DateTimePickerType { date, time }

class ScrollControllerProvider extends InheritedWidget {
  final ScrollController scrollController;

  const ScrollControllerProvider({
    super.key,
    required this.scrollController,
    required super.child,
  });

  static ScrollController of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ScrollControllerProvider>();
    return provider!.scrollController;
  }

  @override
  bool updateShouldNotify(ScrollControllerProvider oldWidget) {
    return scrollController != oldWidget.scrollController;
  }
}

class VoicesDatePicker extends StatefulWidget {
  final DatePickerController controller;
  const VoicesDatePicker({
    super.key,
    required this.controller,
  });

  @override
  State<VoicesDatePicker> createState() => _VoicesDatePickerState();
}

class _VoicesDatePickerState extends State<VoicesDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CalendarFieldPicker(
          controller: widget.controller.calendarPickerController,
        ),
        TimeFieldPicker(
          controller: widget.controller.timePickerController,
          timeZone: 'UTC',
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
  }
}
