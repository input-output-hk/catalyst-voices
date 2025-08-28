import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/pages/voting/widgets/voting_list/voting_list_bottom_sheet_actions.dart';
import 'package:catalyst_voices/pages/voting/widgets/voting_list/voting_list_bottom_sheet_confirm_password.dart';
import 'package:catalyst_voices/pages/voting/widgets/voting_list/voting_list_bottom_sheet_result.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingListBottomSheet extends StatefulWidget {
  const VotingListBottomSheet({
    super.key,
  });

  @override
  State<VotingListBottomSheet> createState() => _VotingListBottomSheetState();
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

class _VotingListBottomSheetState extends State<VotingListBottomSheet>
    with SignalHandlerStateMixin<VotingBallotBloc, VotingBallotSignal, VotingListBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingBallotBloc, VotingBallotState, VotingListCastingStep>(
      selector: (state) {
        return state.footer.castingStep;
      },
      builder: (context, state) {
        return switch (state) {
          ConfirmPasswordStep(:final isLoading, :final exception) =>
            VotingListBottomSheetConfirmPassword(
              isLoading: isLoading,
              exception: exception,
            ),
          SuccessfullyCastVotesStep() => const VotingListBottomSheetSuccessResult(),
          FailedToCastVotesStep() => const VotingListBottomSheetFailedResult(),
          _ => const SizedBox(),
        };
      },
    );
  }

  @override
  void handleSignal(VotingBallotSignal signal) {
    switch (signal) {
      case HideBottomSheetSignal():
        VoicesDrawer.of(context).hideBottomSheet();
      case ShowBottomSheetSignal():
        VoicesDrawer.of(context).showBottomSheet();
    }
  }
}
