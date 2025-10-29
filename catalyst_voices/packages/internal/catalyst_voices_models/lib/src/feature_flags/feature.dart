import 'package:catalyst_voices_models/src/feature_flags/feature_name.dart';
import 'package:equatable/equatable.dart';

final class Feature extends Equatable {
  final FeatureName name;
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
