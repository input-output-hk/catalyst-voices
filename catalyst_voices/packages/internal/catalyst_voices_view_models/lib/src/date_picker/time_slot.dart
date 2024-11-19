import 'package:equatable/equatable.dart';

class TimeSlot extends Equatable {
  final int hour;
  final int minute;

  const TimeSlot({required this.hour, required this.minute});

  String get formattedTime =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  DateTime get dateTime => DateTime(0, 0, 0, hour, minute);

  @override
  List<Object?> get props => [hour, minute];
}
