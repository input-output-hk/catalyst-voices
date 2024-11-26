part of '../voices_date_time_picker.dart';

class VoicesTimePicker extends StatefulWidget {
  final ValueChanged<DateTime> onTap;
  final String? selectedTime;
  final String timeZone;

  const VoicesTimePicker({
    super.key,
    required this.onTap,
    this.selectedTime,
    required this.timeZone,
  });

  @override
  State<VoicesTimePicker> createState() => _VoicesTimePickerState();
}

class _VoicesTimePickerState extends State<VoicesTimePicker> {
  late final ScrollController _scrollController;
  final double itemExtent = 40;
  List<TimeSlot> get timeList => _generateTimeList();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    final initialSelection = widget.selectedTime;
    if (initialSelection != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToTimeZone(initialSelection);
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
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
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
          itemCount: timeList.length,
          itemBuilder: (context, index) => _TimeText(
            key: ValueKey(timeList[index].formattedTime),
            value: timeList[index],
            onTap: widget.onTap,
            selectedTime: widget.selectedTime,
            timeZone: widget.timeZone,
          ),
        ),
      ),
    );
  }

  void _scrollToTimeZone(String value) {
    final index =
        timeList.indexWhere((e) => e.formattedTime == widget.selectedTime);
    if (index != -1) {
      _scrollController.jumpTo(
        index * itemExtent,
      );
    }
  }

  List<TimeSlot> _generateTimeList() {
    return [
      for (var hour = 0; hour < 24; hour++)
        for (final minute in [0, 30]) TimeSlot(hour: hour, minute: minute),
    ];
  }
}

class _TimeText extends StatelessWidget {
  final ValueChanged<DateTime> onTap;
  final TimeSlot value;
  final String? selectedTime;
  final String timeZone;

  const _TimeText({
    super.key,
    required this.value,
    required this.onTap,
    this.selectedTime,
    required this.timeZone,
  });

  bool get isSelected => selectedTime == value;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(value.dateTime),
        child: ColoredBox(
          color: !isSelected
              ? Colors.transparent
              : Theme.of(context).colors.onSurfaceNeutral08!,
          child: Padding(
            key: key,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value.formattedTime,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (isSelected) Text(timeZone),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
