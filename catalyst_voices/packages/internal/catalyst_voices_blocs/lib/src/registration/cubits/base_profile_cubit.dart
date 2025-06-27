import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';

final class BaseProfileCubit extends Cubit<BaseProfileStateData>
    with BlocErrorEmitterMixin
    implements BaseProfileManager {
  BaseProfileCubit()
      : super(
          kDebugMode
              ? const BaseProfileStateData(
                  email: Email.dirty('dev@iokh.com'),
                  username: Username.dirty('Dev'),
                  conditionsAccepted: true,
                  tosAndPrivacyPolicyAccepted: true,
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
  void updateConditions({
    required bool accepted,
  }) {
    emit(state.copyWith(conditionsAccepted: accepted));
  }

  @override
  void updateEmail(Email value) {
    emit(state.copyWith(email: value));
  }

  @override
  void updateTosAndPrivacyPolicy({
    required bool accepted,
  }) {
    emit(state.copyWith(tosAndPrivacyPolicyAccepted: accepted));
  }

  @override
  void updateUsername(Username value) {
    emit(state.copyWith(username: value));
  }
}

abstract interface class BaseProfileManager {
  void updateConditions({required bool accepted});

  void updateEmail(Email value);

  void updateTosAndPrivacyPolicy({required bool accepted});

  void updateUsername(Username value);
}
