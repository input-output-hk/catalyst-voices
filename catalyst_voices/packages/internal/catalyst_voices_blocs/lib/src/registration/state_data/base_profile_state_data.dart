import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class BaseProfileStateData extends Equatable {
  final Email email;
  final DisplayName displayName;
  final bool isToSAccepted;
  final bool isPrivacyPolicyAccepted;
  final bool isDataUsageAccepted;

  const BaseProfileStateData({
    this.email = const Email.pure(),
    this.displayName = const DisplayName.pure(),
    this.isToSAccepted = false,
    this.isPrivacyPolicyAccepted = false,
    this.isDataUsageAccepted = false,
  });

  bool get isCompleted => isBaseProfileDataValid && arAcknowledgementsAccepted;

  bool get isBaseProfileDataValid => email.isValid && displayName.isValid;

  bool get arAcknowledgementsAccepted {
    return isToSAccepted && isPrivacyPolicyAccepted && isDataUsageAccepted;
  }

  BaseProfileStateData copyWith({
    Email? email,
    DisplayName? displayName,
    bool? isToSAccepted,
    bool? isPrivacyPolicyAccepted,
    bool? isDataUsageAccepted,
  }) {
    return BaseProfileStateData(
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      isToSAccepted: isToSAccepted ?? this.isToSAccepted,
      isPrivacyPolicyAccepted:
          isPrivacyPolicyAccepted ?? this.isPrivacyPolicyAccepted,
      isDataUsageAccepted: isDataUsageAccepted ?? this.isDataUsageAccepted,
    );
  }

  @override
  List<Object?> get props => [
        email,
        displayName,
        isToSAccepted,
        isPrivacyPolicyAccepted,
        isDataUsageAccepted,
      ];
}
