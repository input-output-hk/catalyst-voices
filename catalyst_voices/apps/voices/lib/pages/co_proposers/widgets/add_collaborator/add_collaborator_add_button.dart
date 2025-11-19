import 'dart:async';

import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/indicators/voices_circular_progress_indicator.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class AddCollaboratorAddButton extends StatelessWidget {
  const AddCollaboratorAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AddCollaboratorCubit, AddCollaboratorState, CollaboratorIdState>(
      selector: (state) {
        return state.collaboratorIdState;
      },
      builder: (context, collaboratorIdState) {
        return _AddCollaboratorAddButton(collaboratorIdState);
      },
    );
  }
}

class _AddCollaboratorAddButton extends StatelessWidget {
  final CollaboratorIdState collaboratorIdState;

  const _AddCollaboratorAddButton(this.collaboratorIdState);

  @override
  Widget build(BuildContext context) {
    final isValid =
        collaboratorIdState.collaboratorId.isValid && !collaboratorIdState.collaboratorId.isPure;

    return VoicesFilledButton(
      onTap: isValid
          ? () {
              if (collaboratorIdState.isLoading) return;

              unawaited(context.read<AddCollaboratorCubit>().validateCollaboratorId());
            }
          : null,
      trailing: collaboratorIdState.isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: VoicesCircularProgressIndicator(),
            )
          : null,
      child: Text(context.l10n.addCollaborator),
    );
  }
}
