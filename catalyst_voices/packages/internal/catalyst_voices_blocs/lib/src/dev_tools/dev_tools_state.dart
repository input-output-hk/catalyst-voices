import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class DevToolsState extends Equatable {
  final int enableTapCount;
  final bool isDeveloper;
  final SystemInfo? systemInfo;
  final SyncStats? syncStats;
  final int? documentsCount;

  const DevToolsState({
    this.enableTapCount = 0,
    this.isDeveloper = false,
    this.systemInfo,
    this.syncStats,
    this.documentsCount,
  });

  @override
  List<Object?> get props => [
        enableTapCount,
        isDeveloper,
        systemInfo,
        syncStats,
        documentsCount,
      ];

  DevToolsState copyWith({
    int? enableTapCount,
    bool? isDeveloper,
    Optional<SystemInfo>? systemInfo,
    Optional<SyncStats>? syncStats,
    Optional<int>? documentsCount,
  }) {
    return DevToolsState(
      enableTapCount: enableTapCount ?? this.enableTapCount,
      isDeveloper: isDeveloper ?? this.isDeveloper,
      systemInfo: systemInfo.dataOr(this.systemInfo),
      syncStats: syncStats.dataOr(this.syncStats),
      documentsCount: documentsCount.dataOr(this.documentsCount),
    );
  }
}
