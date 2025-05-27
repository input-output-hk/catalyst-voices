import 'package:catalyst_voices_shared/catalyst_voices_shared.dart' show Level;
import 'package:equatable/equatable.dart';

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

final class RecoverConfigEvent extends DevToolsEvent {
  const RecoverConfigEvent();
}

final class UpdateSystemInfoEvent extends DevToolsEvent {
  const UpdateSystemInfoEvent();
}
