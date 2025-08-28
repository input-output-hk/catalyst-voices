import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class VotingLeadingButton extends StatelessWidget {
  const VotingLeadingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BackButton(
      onPressed: () {
        context.read<VotingCubit>().changeSelectedCategory(null);
      },
    );
  }
}
