import 'package:equatable/equatable.dart';

final class Feature extends Equatable {
  final String name;
  final String description;
  final bool defaultValue;

  const Feature({
    required this.name,
    required this.description,
    this.defaultValue = false,
  });

  @override
  List<Object?> get props => [name, description, defaultValue];
}
