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

final GlobalKey calendarKey = GlobalKey();
final GlobalKey timeKey = GlobalKey();

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

  static ScrollController? maybeOf(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ScrollControllerProvider>();
    return provider?.scrollController;
  }

  @override
  bool updateShouldNotify(ScrollControllerProvider oldWidget) {
    return scrollController != oldWidget.scrollController;
  }
}

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
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CalendarFieldPicker(
          key: calendarKey,
          controller: widget.controller.calendarPickerController,
        ),
        TimeFieldPicker(
          key: timeKey,
          controller: widget.controller.timePickerController,
          timeZone: widget.timeZone,
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
