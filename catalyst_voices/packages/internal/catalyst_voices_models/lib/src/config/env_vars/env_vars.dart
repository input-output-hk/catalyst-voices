import 'package:equatable/equatable.dart';

final class EnvVars extends Equatable {
  final String? envName;
  final String? configUrl;

  const EnvVars({
    this.envName,
    this.configUrl,
  });

  @override
  List<Object?> get props => [
        envName,
        configUrl,
      ];
}
