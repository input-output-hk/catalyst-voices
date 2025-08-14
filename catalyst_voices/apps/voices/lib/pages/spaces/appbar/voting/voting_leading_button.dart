import 'package:catalyst_voices/widgets/buttons/voices_buttons.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class VotingLeadingButton extends StatelessWidget {
  const VotingLeadingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<VotingCubit>();

    return BlocSelector<VotingCubit, VotingState, bool>(
      bloc: cubit,
      selector: (state) => state.selectedCategory != null,
      builder: (context, hasCategory) {
        if (hasCategory) {
          return BackButton(
            onPressed: () {
              cubit.changeSelectedCategory(null);
            },
          );
        } else {
          return const DrawerToggleButton();
        }
      },
    );
  }
}
