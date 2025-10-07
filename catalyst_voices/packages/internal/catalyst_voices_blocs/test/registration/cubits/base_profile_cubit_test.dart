import 'package:bloc_test/bloc_test.dart';
import 'package:catalyst_voices_blocs/src/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/registration/cubits/base_profile_cubit.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(BaseProfileCubit, () {
    late BaseProfileCubit baseProfileCubit;

    setUp(() {
      baseProfileCubit = BaseProfileCubit();
    });

    tearDown(() async {
      await baseProfileCubit.close();
    });

    test('creates recovery progress with current username and email', () {
      baseProfileCubit
        ..updateUsername(const Username.dirty('testuser'))
        ..updateEmail(const Email.dirty('test@example.com'));

      final progress = baseProfileCubit.createRecoverProgress();

      expect(progress.username, 'testuser');
      expect(progress.email, 'test@example.com');
    });

    blocTest<BaseProfileCubit, BaseProfileStateData>(
      'emits updated conditionsAccepted when updateConditions is called with true',
      build: () => baseProfileCubit,
      act: (cubit) => cubit.updateConditions(accepted: true),
      expect: () => [
        isA<BaseProfileStateData>().having((e) => e.conditionsAccepted, 'conditionsAccepted', true),
      ],
    );

    blocTest<BaseProfileCubit, BaseProfileStateData>(
      'emits updated conditionsAccepted when updateConditions is called with false',
      build: () => baseProfileCubit,
      act: (cubit) => cubit.updateConditions(accepted: false),
      expect: () => [
        isA<BaseProfileStateData>().having(
          (e) => e.conditionsAccepted,
          'conditionsAccepted',
          false,
        ),
      ],
    );

    blocTest<BaseProfileCubit, BaseProfileStateData>(
      'emits updated drepApprovalContingencyAccepted when updateDrepApprovalContingency is called with true',
      build: () => baseProfileCubit,
      act: (cubit) => cubit.updateDrepApprovalContingency(accepted: true),
      expect: () => [
        isA<BaseProfileStateData>().having(
          (e) => e.drepApprovalContingencyAccepted,
          'drepApprovalContingencyAccepted',
          true,
        ),
      ],
    );

    blocTest<BaseProfileCubit, BaseProfileStateData>(
      'emits updated drepApprovalContingencyAccepted when updateDrepApprovalContingency is called with false',
      build: () => baseProfileCubit,
      act: (cubit) => cubit.updateDrepApprovalContingency(accepted: false),
      expect: () => [
        isA<BaseProfileStateData>().having(
          (e) => e.drepApprovalContingencyAccepted,
          'drepApprovalContingencyAccepted',
          false,
        ),
      ],
    );

    blocTest<BaseProfileCubit, BaseProfileStateData>(
      'emits updated email when updateEmail is called with valid email',
      build: () => baseProfileCubit,
      act: (cubit) => cubit.updateEmail(const Email.dirty('test@example.com')),
      expect: () => [
        isA<BaseProfileStateData>()
            .having((e) => e.email.value, 'email', 'test@example.com')
            .having((e) => e.receiveEmails.isEnabled, 'receiveEmails.isEnabled', true),
      ],
    );

    blocTest<BaseProfileCubit, BaseProfileStateData>(
      'emits updated email with disabled receiveEmails when updateEmail is called with invalid email',
      build: () => baseProfileCubit,
      act: (cubit) => cubit.updateEmail(const Email.dirty('invalid')),
      expect: () => [
        isA<BaseProfileStateData>()
            .having((e) => e.email.value, 'email', 'invalid')
            .having((e) => e.receiveEmails.isEnabled, 'receiveEmails.isEnabled', false)
            .having((e) => e.receiveEmails.isAccepted, 'receiveEmails.isAccepted', false),
      ],
    );

    blocTest<BaseProfileCubit, BaseProfileStateData>(
      'emits updated email with disabled receiveEmails when updateEmail is called with empty email',
      build: () => baseProfileCubit,
      act: (cubit) => cubit.updateEmail(const Email.dirty()),
      expect: () => [
        isA<BaseProfileStateData>()
            .having((e) => e.email.value, 'email', '')
            .having((e) => e.receiveEmails.isEnabled, 'receiveEmails.isEnabled', false)
            .having((e) => e.receiveEmails.isAccepted, 'receiveEmails.isAccepted', false),
      ],
    );

    blocTest<BaseProfileCubit, BaseProfileStateData>(
      'emits updated receiveEmails when updateReceiveEmails is called with true',
      build: () => baseProfileCubit,
      act: (cubit) => cubit.updateReceiveEmails(isAccepted: true),
      expect: () => [
        isA<BaseProfileStateData>().having(
          (e) => e.receiveEmails.isAccepted,
          'receiveEmails.isAccepted',
          true,
        ),
      ],
    );

    blocTest<BaseProfileCubit, BaseProfileStateData>(
      'emits updated receiveEmails when updateReceiveEmails is called with false',
      build: () => baseProfileCubit,
      act: (cubit) => cubit.updateReceiveEmails(isAccepted: false),
      expect: () => [
        isA<BaseProfileStateData>().having(
          (e) => e.receiveEmails.isAccepted,
          'receiveEmails.isAccepted',
          false,
        ),
      ],
    );

    blocTest<BaseProfileCubit, BaseProfileStateData>(
      'emits updated tosAndPrivacyPolicyAccepted when updateTosAndPrivacyPolicy is called with true',
      build: () => baseProfileCubit,
      act: (cubit) => cubit.updateTosAndPrivacyPolicy(accepted: true),
      expect: () => [
        isA<BaseProfileStateData>().having(
          (e) => e.tosAndPrivacyPolicyAccepted,
          'tosAndPrivacyPolicyAccepted',
          true,
        ),
      ],
    );

    blocTest<BaseProfileCubit, BaseProfileStateData>(
      'emits updated tosAndPrivacyPolicyAccepted when updateTosAndPrivacyPolicy is called with false',
      build: () => baseProfileCubit,
      act: (cubit) => cubit.updateTosAndPrivacyPolicy(accepted: false),
      expect: () => [
        isA<BaseProfileStateData>().having(
          (e) => e.tosAndPrivacyPolicyAccepted,
          'tosAndPrivacyPolicyAccepted',
          false,
        ),
      ],
    );

    blocTest<BaseProfileCubit, BaseProfileStateData>(
      'emits updated username when updateUsername is called',
      build: () => baseProfileCubit,
      act: (cubit) => cubit.updateUsername(const Username.dirty('testuser')),
      expect: () => [
        isA<BaseProfileStateData>().having((e) => e.username.value, 'username', 'testuser'),
      ],
    );
  });
}
