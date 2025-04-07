import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class AppConfigs extends Equatable {
  final String version;
  final DateTime createdAt;
  final Map<AppEnvironmentType, AppConfig> environments;

  const AppConfigs({
    required this.version,
    required this.createdAt,
    required this.environments,
  });

  @override
  List<Object?> get props => [
        version,
        createdAt,
        environments,
      ];
}
