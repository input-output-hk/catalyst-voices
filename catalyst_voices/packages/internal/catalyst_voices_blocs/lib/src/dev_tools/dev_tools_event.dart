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

final class SyncDocumentsEvent extends DevToolsEvent {
  const SyncDocumentsEvent();
}

final class UpdateAllEvent extends DevToolsEvent {
  const UpdateAllEvent();
}

final class UpdateSystemInfoEvent extends DevToolsEvent {
  const UpdateSystemInfoEvent();
}
