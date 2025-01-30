import 'dart:async';

import 'package:catalyst_voices/common/ext/text_editing_controller_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountDisplayNameTile extends StatefulWidget {
  const AccountDisplayNameTile({
    super.key,
  });

  @override
  State<AccountDisplayNameTile> createState() => _AccountDisplayNameTileState();
}

class _AccountDisplayNameTileState extends State<AccountDisplayNameTile> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  bool _isEditMode = false;
  DisplayName _displayName = const DisplayName.pure();
  StreamSubscription<DisplayName>? _sub;

  @override
  void initState() {
    super.initState();

    final bloc = context.read<AccountCubit>();
    final text = bloc.state.displayName.value;
    final value = TextEditingValueExt.collapsedAtEndOf(text);
    _controller = TextEditingController.fromValue(value);
    _controller.addListener(_handleControllerChange);
    _displayName = bloc.state.displayName;

    _focusNode = FocusNode();

    _sub = bloc.stream
        .map((event) => event.displayName)
        .distinct()
        .listen(_handleDisplayNameChange);
  }

  @override
  void dispose() {
    unawaited(_sub?.cancel());
    _sub = null;

    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EditableTile(
      title: context.l10n.displayName,
      onChanged: _handleEditModeChange,
      initialEditMode: _isEditMode,
      isSaveEnabled: _displayName.isValid,
      child: VoicesDisplayNameTextField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: VoicesTextFieldDecoration(
          hintText: context.l10n.displayName,
          errorText: _displayName.displayError?.message(context),
        ),
        onFieldSubmitted: null,
        readOnly: !_isEditMode,
        maxLength: _isEditMode ? DisplayName.lengthRange.max : null,
      ),
    );
  }

  void _handleEditModeChange(EditableTileChange value) {
    setState(() {
      _isEditMode = value.isEditMode;

      // TODO(damian-molinski): for some reason text is selected.
      if (value.isEditMode) {
        _focusNode.requestFocus();
      }

      switch (value.source) {
        case EditableTileChangeSource.cancel:
          if (!value.isEditMode) {
            _onCancel();
          }
        case EditableTileChangeSource.save:
          _onSave();
      }
    });
  }

  void _onCancel() {
    final displayName = context.read<AccountCubit>().state.displayName;
    _controller.textWithSelection = displayName.value;
  }

  void _onSave() {
    unawaited(context.read<AccountCubit>().updateDisplayName(_displayName));
  }

  void _handleControllerChange() {
    setState(() {
      _displayName = DisplayName.dirty(_controller.text);
    });
  }

  void _handleDisplayNameChange(DisplayName displayName) {
    if (_isEditMode) {
      return;
    }

    _controller.textWithSelection = displayName.value;
  }
}
