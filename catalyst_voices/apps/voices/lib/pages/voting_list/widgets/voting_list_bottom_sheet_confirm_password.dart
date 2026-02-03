import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/voting_list/widgets/voting_list_bottom_sheet.dart';
import 'package:catalyst_voices/widgets/text_field/voices_password_text_field.dart';
import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingListBottomSheetConfirmPassword extends StatefulWidget {
  final bool isLoading;
  final LocalizedException? exception;

  const VotingListBottomSheetConfirmPassword({super.key, required this.isLoading, this.exception});

  @override
  State<VotingListBottomSheetConfirmPassword> createState() =>
      _VotingListBottomSheetConfirmPasswordState();
}

class _VotingListBottomSheetConfirmPasswordState
    extends State<VotingListBottomSheetConfirmPassword> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return VotingListBottomSheetContent(
      nextAction: () {
        onUnlock(_passwordController.text);
      },
      nextActionText: context.l10n.confirm,
      isLoading: widget.isLoading,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.confirmYourVoteSubmission,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colors.textOnPrimaryLevel1,
            ),
          ),
          const SizedBox(height: 12),
          Text(context.l10n.voteSubmissionDescription),
          const SizedBox(height: 32),
          VoicesPasswordTextField(
            autofocus: true,
            controller: _passwordController,
            decoration: VoicesTextFieldDecoration(
              labelText: context.l10n.labelEnterYourUnlockPassword,
              errorText: widget.exception?.message(context),
              hintText: context.l10n.passwordLabelText,
              borderRadius: BorderRadius.circular(8),
            ),
            onSubmitted: onUnlock,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void onUnlock(String password) {
    final unlockFactor = PasswordLockFactor(password);

    context.read<VotingBallotBloc>().add(CheckPasswordEvent(unlockFactor));
  }
}
