import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Determines the state of the user profile.
sealed class UserProfileState extends Equatable {
  const UserProfileState();
}

/// The user hasn't login yet.
final class VisitorUserProfileState extends UserProfileState {
  const VisitorUserProfileState();

  @override
  List<Object?> get props => [];
}

/// The user has logged in.
final class ActiveUserProfileState extends UserProfileState {
  final User user;

  const ActiveUserProfileState({required this.user});

  @override
  List<Object?> get props => [user];
}
