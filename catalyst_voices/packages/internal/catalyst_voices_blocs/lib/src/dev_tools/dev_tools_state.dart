import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class DevToolsState extends Equatable {
  final int enableTapCount;
  final bool isDeveloper;
  final SystemInfo? systemInfo;

  const DevToolsState({
    this.enableTapCount = 0,
    this.isDeveloper = false,
    this.systemInfo,
  });

  @override
  List<Object?> get props => [
        enableTapCount,
        isDeveloper,
        systemInfo,
      ];

  DevToolsState copyWith({
    int? enableTapCount,
    bool? isDeveloper,
    Optional<SystemInfo>? systemInfo,
  }) {
    return DevToolsState(
      enableTapCount: enableTapCount ?? this.enableTapCount,
      isDeveloper: isDeveloper ?? this.isDeveloper,
      systemInfo: systemInfo.dataOr(this.systemInfo),
    );
  }
}
