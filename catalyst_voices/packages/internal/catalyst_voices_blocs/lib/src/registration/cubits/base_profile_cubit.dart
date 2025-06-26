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
                  receiveEmails: ReceiveEmails(isAccepted: true, isEnabled: true),
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
    final receiveEmails = state.receiveEmails.copyWith(
      isAccepted: value.isNotValid ? false : null,
      isEnabled: value.isNonEmptyAndValid,
    );

    emit(state.copyWith(email: value, receiveEmails: receiveEmails));
  }

  @override
  void updatePrivacyPolicy({
    required bool isAccepted,
  }) {
    emit(state.copyWith(isPrivacyPolicyAccepted: isAccepted));
  }

  @override
  void updateReceiveEmails({required bool isAccepted}) {
    final receiveEmails = state.receiveEmails.copyWith(isAccepted: isAccepted);
    emit(state.copyWith(receiveEmails: receiveEmails));
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

  void updateReceiveEmails({required bool isAccepted});

  void updateToS({required bool isAccepted});

  void updateUsername(Username value);
}
