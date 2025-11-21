import 'package:equatable/equatable.dart';

final class FeatureAppEnvironmentTypeSetting extends Equatable {
  final bool available;
  final bool enabledByDefault;

  const FeatureAppEnvironmentTypeSetting({
    this.available = false,
    this.enabledByDefault = false,
  });

  @override
  List<Object?> get props => [available, enabledByDefault];
}
