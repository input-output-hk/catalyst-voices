import 'package:equatable/equatable.dart';

final class ComponentStatus extends Equatable {
  final String name;
  final bool isOperational;

  const ComponentStatus({
    required this.name,
    required this.isOperational,
  });

  @override
  List<Object?> get props => [name, isOperational];
}
