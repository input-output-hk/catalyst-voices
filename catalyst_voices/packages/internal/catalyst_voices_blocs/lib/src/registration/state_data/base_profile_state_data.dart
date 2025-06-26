import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class BaseProfileStateData extends Equatable {
  final Email email;
  final ReceiveEmails receiveEmails;
  final Username username;
  final bool isToSAccepted;
  final bool isPrivacyPolicyAccepted;

  const BaseProfileStateData({
    this.email = const Email.pure(),
    this.receiveEmails = const ReceiveEmails(),
    this.username = const Username.pure(),
    this.isToSAccepted = false,
    this.isPrivacyPolicyAccepted = false,
  });

  bool get arAcknowledgementsAccepted => isToSAccepted && isPrivacyPolicyAccepted;

  bool get isBaseProfileDataValid {
    if (!email.isValid || !username.isValid) {
      return false;
    }

    if (email.isNonEmptyAndValid && !receiveEmails.isAccepted) {
      return false;
    }

    return true;
  }

  bool get isCompleted => isBaseProfileDataValid && arAcknowledgementsAccepted;

  @override
  List<Object?> get props => [
        email,
        username,
        receiveEmails,
        isToSAccepted,
        isPrivacyPolicyAccepted,
      ];

  BaseProfileStateData copyWith({
    Email? email,
    ReceiveEmails? receiveEmails,
    Username? username,
    bool? isToSAccepted,
    bool? isPrivacyPolicyAccepted,
  }) {
    return BaseProfileStateData(
      email: email ?? this.email,
      receiveEmails: receiveEmails ?? this.receiveEmails,
      username: username ?? this.username,
      isToSAccepted: isToSAccepted ?? this.isToSAccepted,
      isPrivacyPolicyAccepted: isPrivacyPolicyAccepted ?? this.isPrivacyPolicyAccepted,
    );
  }
}
