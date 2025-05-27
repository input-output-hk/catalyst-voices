import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart' show Level;
import 'package:equatable/equatable.dart';

final class ChangeCollectLogsEvent extends DevToolsEvent {
  final bool isEnabled;

  const ChangeCollectLogsEvent({required this.isEnabled});

  @override
  List<Object?> get props => [isEnabled];
}

final class ChangeLogLevelEvent extends DevToolsEvent {
  final Level? level;

  const ChangeLogLevelEvent(this.level);

  @override
  List<Object?> get props => [level];
}

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

final class PrepareAndExportLogsEvent extends DevToolsEvent {
  const PrepareAndExportLogsEvent();
}

final class RecoverConfigEvent extends DevToolsEvent {
  const RecoverConfigEvent();
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
