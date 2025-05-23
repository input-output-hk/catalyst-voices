import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class DevToolsEnablerTappedEvent extends DevToolsEvent {
  const DevToolsEnablerTappedEvent();
}

final class DevToolsEnablerTapResetEvent extends DevToolsEvent {
  const DevToolsEnablerTapResetEvent();
}

sealed class DevToolsEvent extends Equatable {
  const DevToolsEvent();

  @override
  List<Object?> get props => [];
}

final class RecoverDataEvent extends DevToolsEvent {
  const RecoverDataEvent();
}

final class StopWatchingSystemInfoEvent extends DevToolsEvent {
  const StopWatchingSystemInfoEvent();
}

final class SyncDocumentsEvent extends DevToolsEvent {
  const SyncDocumentsEvent();
}

final class SyncStatsChangedEvent extends DevToolsEvent {
  final SyncStats stats;

  const SyncStatsChangedEvent(this.stats);

  @override
  List<Object?> get props => [stats];
}

final class UpdateAllEvent extends DevToolsEvent {
  const UpdateAllEvent();
}

final class UpdateSystemInfoEvent extends DevToolsEvent {
  const UpdateSystemInfoEvent();
}

final class WatchSystemInfoEvent extends DevToolsEvent {
  const WatchSystemInfoEvent();
}
