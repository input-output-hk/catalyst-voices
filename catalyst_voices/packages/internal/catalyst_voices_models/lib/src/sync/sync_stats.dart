import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class SyncStats extends Equatable {
  final DateTime? lastSuccessfulSyncAt;
  final int? lastAddedRefsCount;
  final Duration? lastSyncDuration;

  const SyncStats({
    this.lastSuccessfulSyncAt,
    this.lastAddedRefsCount,
    this.lastSyncDuration,
  });

  @override
  List<Object?> get props => [
        lastSuccessfulSyncAt,
        lastAddedRefsCount,
        lastSyncDuration,
      ];

  SyncStats copyWith({
    Optional<DateTime>? lastSuccessfulSyncAt,
    Optional<int>? lastAddedRefsCount,
    Optional<Duration>? lastSyncDuration,
  }) {
    return SyncStats(
      lastSuccessfulSyncAt: lastSuccessfulSyncAt.dataOr(this.lastSuccessfulSyncAt),
      lastAddedRefsCount: lastAddedRefsCount.dataOr(this.lastAddedRefsCount),
      lastSyncDuration: lastSyncDuration.dataOr(this.lastSyncDuration),
    );
  }
}
