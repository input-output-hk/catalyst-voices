part of 'voices_date_picker_field.dart';

class VoicesCalendarDatePicker extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback cancelEvent;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  factory VoicesCalendarDatePicker({
    Key? key,
    required ValueChanged<DateTime> onDateSelected,
    required VoidCallback cancelEvent,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    final now = DateTime.now();
    return VoicesCalendarDatePicker._(
      key: key,
      onDateSelected: onDateSelected,
      initialDate: initialDate ?? now,
      firstDate: firstDate ?? now,
      lastDate: lastDate ?? DateTime(now.year + 1, now.month, now.day),
      cancelEvent: cancelEvent,
    );
  }

  const VoicesCalendarDatePicker._({
    super.key,
    required this.onDateSelected,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.cancelEvent,
  });

  @override
  State<VoicesCalendarDatePicker> createState() =>
      _VoicesCalendarDatePickerState();
}

class _VoicesCalendarDatePickerState extends State<VoicesCalendarDatePicker> {
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 450,
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1Grey,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              CalendarDatePicker(
                initialDate: widget.initialDate,
                firstDate: widget.firstDate,
                lastDate: widget.lastDate,
                onDateChanged: (val) {
                  selectedDate = val;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    VoicesTextButton(
                      onTap: widget.cancelEvent,
                      child: Text(context.l10n.cancelButtonText),
                    ),
                    VoicesTextButton(
                      onTap: () => widget.onDateSelected(selectedDate),
                      child: Text(context.l10n.ok.toUpperCase()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
