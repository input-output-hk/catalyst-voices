part of 'voices_date_picker_field.dart';

class VoicesTimePicker extends StatefulWidget {
  final ValueChanged<String> onTap;
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
  List<String> get timeList => _generateTimeList();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    if (widget.selectedTime != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final index = timeList.indexOf(widget.selectedTime!);
        if (index != -1) {
          _scrollController.jumpTo(
            index * 40.0,
          );
        }
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
        child: ListView(
          controller: _scrollController,
          children: timeList
              .map(
                (e) => TimeText(
                  key: ValueKey(e),
                  value: e,
                  onTap: widget.onTap,
                  selectedTime: widget.selectedTime,
                  timeZone: widget.timeZone,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  List<String> _generateTimeList() {
    final times = <String>[];

    for (var hour = 0; hour < 24; hour++) {
      for (var minute = 0; minute < 60; minute += 30) {
        times.add(
          // ignore: lines_longer_than_80_chars
          '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
        );
      }
    }

    return times;
  }
}

class TimeText extends StatelessWidget {
  final ValueChanged<String> onTap;
  final String value;
  final String? selectedTime;
  final String timeZone;
  const TimeText({
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
        onTap: () => onTap(value),
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
                  value,
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
