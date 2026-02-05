import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/voting_list/widgets/voting_list_bottom_sheet_actions.dart';
import 'package:catalyst_voices/pages/voting_list/widgets/voting_list_bottom_sheet_confirm_password.dart';
import 'package:catalyst_voices/pages/voting_list/widgets/voting_list_bottom_sheet_result.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingListBottomSheet extends StatelessWidget {
  const VotingListBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingBallotBloc, VotingBallotState, VotingListCastingStep>(
      selector: (state) {
        return state.footer.castingStep;
      },
      builder: (context, state) {
        return switch (state) {
          ConfirmPasswordStep(:final isLoading, :final isRepresentative, :final exception) =>
            VotingListBottomSheetConfirmPassword(
              isLoading: isLoading,
              isRepresentative: isRepresentative,
              exception: exception,
            ),
          SuccessfullyCastVotesStep() => const VotingListBottomSheetSuccessResult(),
          FailedToCastVotesStep() => const VotingListBottomSheetFailedResult(),
          _ => const SizedBox(),
        };
      },
    );
  }
}

class VotingListBottomSheetContent extends StatelessWidget {
  final VoidCallback nextAction;
  final String nextActionText;
  final bool isLoading;
  final Widget body;

  const VotingListBottomSheetContent({
    required this.nextAction,
    required this.nextActionText,
    this.isLoading = false,
    required this.body,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: context.colors.elevationsOnSurfaceNeutralLv0,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          body,
          const SizedBox(height: 32),
          VotingListBottomSheetActions(
            nextAction: nextAction,
            nextActionText: nextActionText,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
