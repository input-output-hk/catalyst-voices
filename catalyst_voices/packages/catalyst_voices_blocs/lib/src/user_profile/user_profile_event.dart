import 'package:equatable/equatable.dart';

/// Describes events that change the user profile.
sealed class UserProfileEvent extends Equatable {
  const UserProfileEvent();
}

/// Dummy implementation of user management,
/// just logins/logouts the user.
final class ToggleUserProfileEvent extends UserProfileEvent {
  const ToggleUserProfileEvent();

  @override
  List<Object?> get props => [];
}
