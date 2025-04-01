import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class AppConfigs extends Equatable {
  final String version;
  final DateTime updatedAt;
  final Map<AppEnvironmentType, AppConfig> environments;

  const AppConfigs({
    required this.version,
    required this.updatedAt,
    required this.environments,
  });

  @override
  List<Object?> get props => [
        version,
        updatedAt,
        environments,
      ];
}
