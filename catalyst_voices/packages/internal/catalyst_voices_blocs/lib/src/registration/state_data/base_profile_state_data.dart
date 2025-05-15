import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class BaseProfileStateData extends Equatable {
  final Email email;
  final Username username;
  final bool isToSAccepted;
  final bool isPrivacyPolicyAccepted;
  final bool isDataUsageAccepted;

  const BaseProfileStateData({
    this.email = const Email.pure(),
    this.username = const Username.pure(),
    this.isToSAccepted = false,
    this.isPrivacyPolicyAccepted = false,
    this.isDataUsageAccepted = false,
  });

  bool get arAcknowledgementsAccepted {
    return isToSAccepted && isPrivacyPolicyAccepted && isDataUsageAccepted;
  }

  bool get isBaseProfileDataValid => email.isValid && username.isValid;

  bool get isCompleted => isBaseProfileDataValid && arAcknowledgementsAccepted;

  @override
  List<Object?> get props => [
        email,
        username,
        isToSAccepted,
        isPrivacyPolicyAccepted,
        isDataUsageAccepted,
      ];

  BaseProfileStateData copyWith({
    Email? email,
    Username? username,
    bool? isToSAccepted,
    bool? isPrivacyPolicyAccepted,
    bool? isDataUsageAccepted,
  }) {
    return BaseProfileStateData(
      email: email ?? this.email,
      username: username ?? this.username,
      isToSAccepted: isToSAccepted ?? this.isToSAccepted,
      isPrivacyPolicyAccepted:
          isPrivacyPolicyAccepted ?? this.isPrivacyPolicyAccepted,
      isDataUsageAccepted: isDataUsageAccepted ?? this.isDataUsageAccepted,
    );
  }
}
