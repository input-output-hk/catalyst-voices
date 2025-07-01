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
    final receiveEmails = state.receiveEmails.copyWith(
      isAccepted: value.isNotValid ? false : null,
      isEnabled: value.isNonEmptyAndValid,
    );

    emit(state.copyWith(email: value, receiveEmails: receiveEmails));
  }

  @override
  void updateReceiveEmails({required bool isAccepted}) {
    final receiveEmails = state.receiveEmails.copyWith(isAccepted: isAccepted);
    emit(state.copyWith(receiveEmails: receiveEmails));
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

  void updateReceiveEmails({required bool isAccepted});

  void updateTosAndPrivacyPolicy({required bool accepted});

  void updateUsername(Username value);
}
