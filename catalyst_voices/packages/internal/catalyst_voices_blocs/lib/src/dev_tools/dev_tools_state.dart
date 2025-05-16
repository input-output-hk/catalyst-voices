import 'package:equatable/equatable.dart';

final class DevToolsState extends Equatable {
  final int enableTapCount;
  final bool isDeveloper;

  const DevToolsState({
    this.enableTapCount = 0,
    this.isDeveloper = false,
  });

  @override
  List<Object?> get props => [
        enableTapCount,
        isDeveloper,
      ];

  DevToolsState copyWith({
    int? enableTapCount,
    bool? isDeveloper,
  }) {
    return DevToolsState(
      enableTapCount: enableTapCount ?? this.enableTapCount,
      isDeveloper: isDeveloper ?? this.isDeveloper,
    );
  }
}
