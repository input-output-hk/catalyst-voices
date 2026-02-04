import 'dart:async';

import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/indicators/voices_circular_progress_indicator.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class AddCollaboratorButton extends StatelessWidget {
  const AddCollaboratorButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AddCollaboratorCubit, AddCollaboratorState, CollaboratorIdState>(
      selector: (state) {
        return state.collaboratorIdState;
      },
      builder: (context, collaboratorIdState) {
        return _AddCollaboratorButton(collaboratorIdState);
      },
    );
  }
}

class _AddCollaboratorButton extends StatelessWidget {
  final CollaboratorIdState collaboratorIdState;

  const _AddCollaboratorButton(this.collaboratorIdState);

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: collaboratorIdState.isValid ? () => _validateCollaboratorId(context) : null,
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

  void _validateCollaboratorId(BuildContext context) {
    if (collaboratorIdState.isLoading) return;

    unawaited(context.read<AddCollaboratorCubit>().validateCollaboratorId());
  }
}
