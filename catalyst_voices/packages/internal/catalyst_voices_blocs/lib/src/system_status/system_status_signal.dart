import 'package:equatable/equatable.dart';

final class CancelSystemStatusIssueSignal extends SystemStatusSignal {
  const CancelSystemStatusIssueSignal();
}

final class NewVersionAvailable extends SystemStatusSignal {
  const NewVersionAvailable();
}

final class SystemStatusIssueSignal extends SystemStatusSignal {
  const SystemStatusIssueSignal();
}

sealed class SystemStatusSignal extends Equatable {
  const SystemStatusSignal();

  @override
  List<Object?> get props => [];
}
