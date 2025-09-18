import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class VotingListBottomSheetActions extends StatelessWidget {
  final VoidCallback nextAction;
  final String nextActionText;
  final bool isLoading;

  const VotingListBottomSheetActions({
    super.key,
    required this.nextAction,
    required this.nextActionText,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 12,
      children: [
        Expanded(
          child: VoicesOutlinedButton(
            onTap: () {
              context.read<VotingBallotBloc>().add(const CancelCastingVotesEvent());
            },
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(context.l10n.cancelButtonText),
          ),
        ),
        Expanded(
          child: AbsorbPointer(
            absorbing: isLoading,
            child: VoicesFilledButton(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onTap: nextAction,
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    )
                  : Text(nextActionText),
            ),
          ),
        ),
      ],
    );
  }
}
