part of 'voices_date_picker_field.dart';

class VoicesTimePicker extends StatelessWidget {
  const VoicesTimePicker({super.key});

  List<String> get timeList => _generateTimeList();

  @override
  Widget build(BuildContext context) {
    return Material(
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
            '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
      }
    }

    return times;
  }
}

class TimeText extends StatelessWidget {
  final String value;
  const TimeText({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
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
