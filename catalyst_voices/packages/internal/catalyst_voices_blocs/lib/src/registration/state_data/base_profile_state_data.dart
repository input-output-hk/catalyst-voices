import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class BaseProfileStateData extends Equatable {
  final Email email;
  final ReceiveEmails receiveEmails;
  final Username username;
  final bool conditionsAccepted;
  final bool tosAndPrivacyPolicyAccepted;
  final bool drepApprovalContingencyAccepted;

  const BaseProfileStateData({
    this.email = const Email.pure(),
    this.receiveEmails = const ReceiveEmails(),
    this.username = const Username.pure(),
    this.conditionsAccepted = false,
    this.tosAndPrivacyPolicyAccepted = false,
    this.drepApprovalContingencyAccepted = false,
  });

  bool get arAcknowledgementsAccepted =>
      conditionsAccepted && tosAndPrivacyPolicyAccepted && drepApprovalContingencyAccepted;

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
        conditionsAccepted,
        tosAndPrivacyPolicyAccepted,
        drepApprovalContingencyAccepted,
      ];

  BaseProfileStateData copyWith({
    Email? email,
    ReceiveEmails? receiveEmails,
    Username? username,
    bool? conditionsAccepted,
    bool? tosAndPrivacyPolicyAccepted,
    bool? drepApprovalContingencyAccepted,
  }) {
    return BaseProfileStateData(
      email: email ?? this.email,
      receiveEmails: receiveEmails ?? this.receiveEmails,
      username: username ?? this.username,
      conditionsAccepted: conditionsAccepted ?? this.conditionsAccepted,
      tosAndPrivacyPolicyAccepted: tosAndPrivacyPolicyAccepted ?? this.tosAndPrivacyPolicyAccepted,
      drepApprovalContingencyAccepted:
          drepApprovalContingencyAccepted ?? this.drepApprovalContingencyAccepted,
    );
  }
}
