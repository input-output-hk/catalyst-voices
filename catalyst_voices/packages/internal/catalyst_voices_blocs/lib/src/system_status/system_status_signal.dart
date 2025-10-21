import 'package:equatable/equatable.dart';

final class SystemStatusIssueSignal extends SystemStatusSignal {
  const SystemStatusIssueSignal();
}

final class CancelSystemStatusIssueSignal extends SystemStatusSignal {
  const CancelSystemStatusIssueSignal();
}

sealed class SystemStatusSignal extends Equatable {
  const SystemStatusSignal();

  @override
  List<Object?> get props => [];
}
