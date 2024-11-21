import 'package:equatable/equatable.dart';

final class Comment extends Equatable {
  final String text;
  final DateTime date;
  final String userName;

  const Comment({
    required this.text,
    required this.date,
    required this.userName,
  });

  @override
  List<Object?> get props => [
        text,
        date,
        userName,
      ];
}
