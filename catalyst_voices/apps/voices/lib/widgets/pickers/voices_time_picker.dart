import 'package:catalyst_voices/common/ext/time_of_day_ext.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class VoicesTimePicker extends StatefulWidget {
  final ValueChanged<TimeOfDay> onTap;
  final TimeOfDay? selectedTime;
  final String? timeZone;

  const VoicesTimePicker({
    super.key,
    required this.onTap,
    this.selectedTime,
    this.timeZone,
  });

  @override
  State<VoicesTimePicker> createState() => _VoicesTimePickerState();
}

class _VoicesTimePickerState extends State<VoicesTimePicker> {
  late final ScrollController _scrollController;
  late final List<TimeOfDay> _timeList;

  final double itemExtent = 40;

  @override
  void initState() {
    super.initState();

    _timeList = _generateTimeList();
    _scrollController = ScrollController();

    final initialSelection = widget.selectedTime;
    if (initialSelection != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToTime(initialSelection);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      clipBehavior: Clip.hardEdge,
      child: Container(
        height: 350,
        width: 150,
        decoration: BoxDecoration(
          color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1Grey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListView.builder(
          controller: _scrollController,
          itemExtent: itemExtent,
          itemCount: _timeList.length,
          itemBuilder: (context, index) {
            final timeOfDay = _timeList[index];

            return _TimeText(
              key: ValueKey(timeOfDay.formatted),
              value: timeOfDay,
              onTap: widget.onTap,
              isSelected: timeOfDay == widget.selectedTime,
              timeZone: widget.timeZone,
            );
          },
        ),
      ),
    );
  }

  void _scrollToTime(TimeOfDay value) {
    final index = _timeList.indexWhere((e) => e == widget.selectedTime);

    if (index != -1) {
      _scrollController.jumpTo(index * itemExtent);
    }
  }

  List<TimeOfDay> _generateTimeList() {
    return [
      for (var hour = 0; hour < 24; hour++)
        for (final minute in [0, 30]) TimeOfDay(hour: hour, minute: minute),
    ];
  }
}

class _TimeText extends StatelessWidget {
  final ValueChanged<TimeOfDay> onTap;
  final TimeOfDay value;
  final bool isSelected;
  final String? timeZone;

  const _TimeText({
    super.key,
    required this.value,
    required this.onTap,
    this.isSelected = false,
    this.timeZone,
  });

  @override
  Widget build(BuildContext context) {
    final timeZone = this.timeZone;

    return Material(
      clipBehavior: Clip.hardEdge,
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => onTap(value),
        child: ColoredBox(
          color: !isSelected
              ? Colors.transparent
              : Theme.of(context).colors.onSurfaceNeutral08,
          child: Padding(
            key: key,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value.formatted,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (isSelected && timeZone != null) Text(timeZone),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
