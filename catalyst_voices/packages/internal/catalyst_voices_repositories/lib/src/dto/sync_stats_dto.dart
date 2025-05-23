import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sync_stats_dto.g.dart';

@JsonSerializable()
final class SyncStatsDto {
  final DateTime? lastSuccessfulSyncAt;
  final int? lastAddedRefsCount;
  final Duration? lastSyncDuration;

  const SyncStatsDto({
    this.lastSuccessfulSyncAt,
    this.lastAddedRefsCount,
    this.lastSyncDuration,
  });

  factory SyncStatsDto.fromJson(Map<String, dynamic> json) {
    return _$SyncStatsDtoFromJson(json);
  }

  SyncStatsDto.fromModel(SyncStats data)
      : this(
          lastSuccessfulSyncAt: data.lastSuccessfulSyncAt,
          lastAddedRefsCount: data.lastAddedRefsCount,
          lastSyncDuration: data.lastSyncDuration,
        );

  Map<String, dynamic> toJson() => _$SyncStatsDtoToJson(this);

  SyncStats toModel() {
    return SyncStats(
      lastSuccessfulSyncAt: lastSuccessfulSyncAt,
      lastAddedRefsCount: lastAddedRefsCount,
      lastSyncDuration: lastSyncDuration,
    );
  }
}
