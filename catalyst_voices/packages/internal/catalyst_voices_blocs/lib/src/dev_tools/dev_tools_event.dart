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

final class RecoverConfigEvent extends DevToolsEvent {
  const RecoverConfigEvent();
}
