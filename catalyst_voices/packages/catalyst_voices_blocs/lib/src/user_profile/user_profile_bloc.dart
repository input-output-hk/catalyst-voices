import 'package:catalyst_voices_blocs/src/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages the user profile.
final class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc() : super(const VisitorUserProfileState()) {
    on<ToggleUserProfileEvent>(_toggleUserProfile);
  }

  void _toggleUserProfile(
    ToggleUserProfileEvent event,
    Emitter<UserProfileState> emit,
  ) {
    final nextState = switch (state) {
      VisitorUserProfileState() =>
        const ActiveUserProfileState(user: User(name: 'John Smith')),
      ActiveUserProfileState() => const VisitorUserProfileState(),
    };

    emit(nextState);
  }
}
