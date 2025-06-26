import 'package:equatable/equatable.dart';

final class ReceiveEmails extends Equatable {
  final bool isAccepted;
  final bool isEnabled;

  const ReceiveEmails({
    this.isAccepted = false,
    this.isEnabled = false,
  });

  ReceiveEmails copyWith({
    bool? isAccepted,
    bool? isEnabled,
  }) {
    return ReceiveEmails(
      isAccepted: isAccepted ?? this.isAccepted,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  List<Object?> get props => [
        isAccepted,
        isEnabled,
      ];
}
