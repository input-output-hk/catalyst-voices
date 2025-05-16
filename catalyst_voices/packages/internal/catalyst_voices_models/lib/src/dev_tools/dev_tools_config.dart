import 'package:equatable/equatable.dart';

final class DevToolsConfig extends Equatable {
  final bool isDeveloper;

  const DevToolsConfig({
    this.isDeveloper = false,
  });

  @override
  List<Object?> get props => [isDeveloper];

  DevToolsConfig copyWith({
    bool? isDeveloper,
  }) {
    return DevToolsConfig(
      isDeveloper: isDeveloper ?? this.isDeveloper,
    );
  }
}
