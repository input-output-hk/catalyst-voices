import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class AddCollaboratorTextField extends StatelessWidget {
  const AddCollaboratorTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AddCollaboratorCubit, AddCollaboratorState, CollaboratorCatalystId>(
      selector: (state) {
        return state.collaboratorIdState.collaboratorId;
      },
      builder: (context, collaboratorId) {
        return _AddCollaboratorTextField(collaboratorId);
      },
    );
  }
}

class __AddCollaboratorTextFieldState extends State<_AddCollaboratorTextField> {
  late final FocusNode _focusNode;

  String? get errorMessage {
    final error = widget.collaboratorId.displayError;
    if (error is InvalidCatalystIdFormatValidationException) {
      return error.message(context);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return VoicesTextField(
      focusNode: _focusNode,
      initialText: widget.collaboratorId.value,
      onChanged: _onTextFieldChange,
      onFieldSubmitted: _onTextFieldSubmitted,
      decoration: VoicesTextFieldDecoration(
        labelText: context.l10n.catalystId,
        labelStyle: context.textTheme.labelLarge,
        errorText: errorMessage,
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..requestFocus();
  }

  void _onTextFieldChange(String? value) {
    context.read<AddCollaboratorCubit>().updateCollaboratorId(value ?? '');
  }

  void _onTextFieldSubmitted(String? value) {
    unawaited(context.read<AddCollaboratorCubit>().validateCollaboratorId());
  }
}

class _AddCollaboratorTextField extends StatefulWidget {
  final CollaboratorCatalystId collaboratorId;

  const _AddCollaboratorTextField(this.collaboratorId);

  @override
  State<_AddCollaboratorTextField> createState() => __AddCollaboratorTextFieldState();
}
