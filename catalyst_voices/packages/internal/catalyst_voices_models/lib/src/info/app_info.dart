import 'package:equatable/equatable.dart';

final class AppInfo extends Equatable {
  final String version;
  final String buildNumber;

  const AppInfo({
    required this.version,
    required this.buildNumber,
  });

  @override
  List<Object?> get props => [
        version,
        buildNumber,
      ];

  AppInfo copyWith({
    String? version,
    String? buildNumber,
  }) {
    return AppInfo(
      version: version ?? this.version,
      buildNumber: buildNumber ?? this.buildNumber,
    );
  }
}
