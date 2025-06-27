import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class BaseProfileStateData extends Equatable {
  final Email email;
  final Username username;
  final bool conditionsAccepted;
  final bool tosAndPrivacyPolicyAccepted;

  const BaseProfileStateData({
    this.email = const Email.pure(),
    this.username = const Username.pure(),
    this.conditionsAccepted = false,
    this.tosAndPrivacyPolicyAccepted = false,
  });

  bool get arAcknowledgementsAccepted => conditionsAccepted && tosAndPrivacyPolicyAccepted;

  bool get isBaseProfileDataValid => email.isValid && username.isValid;

  bool get isCompleted => isBaseProfileDataValid && arAcknowledgementsAccepted;

  @override
  List<Object?> get props => [
        email,
        username,
        conditionsAccepted,
        tosAndPrivacyPolicyAccepted,
      ];

  BaseProfileStateData copyWith({
    Email? email,
    Username? username,
    bool? conditionsAccepted,
    bool? tosAndPrivacyPolicyAccepted,
  }) {
    return BaseProfileStateData(
      email: email ?? this.email,
      username: username ?? this.username,
      conditionsAccepted: conditionsAccepted ?? this.conditionsAccepted,
      tosAndPrivacyPolicyAccepted: tosAndPrivacyPolicyAccepted ?? this.tosAndPrivacyPolicyAccepted,
    );
  }
}
