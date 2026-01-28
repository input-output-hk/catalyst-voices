import 'package:equatable/equatable.dart';

final class SyncIndicatorState extends Equatable {
  final bool isSyncing;

  const SyncIndicatorState({
    this.isSyncing = false,
  });

  @override
  List<Object?> get props => [isSyncing];

  SyncIndicatorState copyWith({
    bool? isSyncing,
  }) {
    return SyncIndicatorState(
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }
}
