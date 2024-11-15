part of 'voices_date_picker_field.dart';

class VoicesTimePicker extends StatelessWidget {
  final ValueChanged<String> onTap;
  const VoicesTimePicker({
    super.key,
    required this.onTap,
  });

  List<String> get timeList => _generateTimeList();

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: Container(
        height: 300,
        width: 150,
        decoration: BoxDecoration(
          color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1Grey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListView(
          children: timeList
              .map(
                (e) => TimeText(
                  value: e,
                  onTap: onTap,
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
  const TimeText({
    super.key,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(value),
        child: Padding(
          key: key,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
