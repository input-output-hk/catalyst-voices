import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final class DevToolsState extends Equatable {
  final int enableTapCount;
  final bool isDeveloper;
  final SystemInfo? systemInfo;
  final bool areLogsOptionsAvailable;
  final Level? logsLevel;
  final bool collectLogs;

  const DevToolsState({
    this.enableTapCount = 0,
    this.isDeveloper = false,
    this.systemInfo,
    this.areLogsOptionsAvailable = false,
    this.logsLevel,
    this.collectLogs = false,
  });

  @override
  List<Object?> get props => [
        enableTapCount,
        isDeveloper,
        systemInfo,
        areLogsOptionsAvailable,
        logsLevel,
        collectLogs,
      ];

  DevToolsState copyWith({
    int? enableTapCount,
    bool? isDeveloper,
    Optional<SystemInfo>? systemInfo,
    bool? areLogsOptionsAvailable,
    Optional<Level>? logsLevel,
    bool? collectLogs,
  }) {
    return DevToolsState(
      enableTapCount: enableTapCount ?? this.enableTapCount,
      isDeveloper: isDeveloper ?? this.isDeveloper,
      systemInfo: systemInfo.dataOr(this.systemInfo),
      areLogsOptionsAvailable: areLogsOptionsAvailable ?? this.areLogsOptionsAvailable,
      logsLevel: logsLevel.dataOr(this.logsLevel),
      collectLogs: collectLogs ?? this.collectLogs,
    );
  }
}
