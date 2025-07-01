import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';

/// Manages the profile data.
final class BaseProfileCubit extends Cubit<BaseProfileStateData>
    with BlocErrorEmitterMixin
    implements BaseProfileManager {
  BaseProfileCubit()
      : super(
          kDebugMode
              ? const BaseProfileStateData(
                  email: Email.dirty('dev@iokh.com'),
                  username: Username.dirty('Dev'),
                  isToSAccepted: true,
                  isPrivacyPolicyAccepted: true,
                )
              : const BaseProfileStateData(),
        );

  BaseProfileProgress createRecoverProgress() {
    return BaseProfileProgress(
      username: state.username.value,
      email: state.email.value,
    );
  }

  @override
  void updateEmail(Email value) {
    emit(state.copyWith(email: value));
  }

  @override
  void updatePrivacyPolicy({
    required bool isAccepted,
  }) {
    emit(state.copyWith(isPrivacyPolicyAccepted: isAccepted));
  }

  @override
  void updateToS({
    required bool isAccepted,
  }) {
    emit(state.copyWith(isToSAccepted: isAccepted));
  }

  @override
  void updateUsername(Username value) {
    emit(state.copyWith(username: value));
  }
}

abstract interface class BaseProfileManager {
  void updateEmail(Email value);

  void updatePrivacyPolicy({required bool isAccepted});

  void updateToS({required bool isAccepted});

  void updateUsername(Username value);
}
