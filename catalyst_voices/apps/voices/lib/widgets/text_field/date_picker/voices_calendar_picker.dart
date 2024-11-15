part of 'voices_date_picker_field.dart';

class VoicesCalendarDatePicker extends StatelessWidget {
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
      lastDate: lastDate ?? now,
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
  Widget build(BuildContext context) {
    var selectedDate = DateTime.now();
    return SizedBox(
      width: 450,
      child: Material(
        clipBehavior: Clip.hardEdge,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1Grey,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 3650)),
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
                      onTap: cancelEvent,
                      child: Text(context.l10n.cancelButtonText),
                    ),
                    VoicesTextButton(
                      onTap: () => onDateSelected(selectedDate),
                      child: Text(context.l10n.snackbarOkButtonText),
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
