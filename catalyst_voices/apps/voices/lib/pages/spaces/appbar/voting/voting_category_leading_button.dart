import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class VotingCategoryLeadingButton extends StatelessWidget {
  const VotingCategoryLeadingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BackButton(
      onPressed: () {
        context.read<VotingCubit>().changeSelectedCategory(null);
      },
    );
  }
}
