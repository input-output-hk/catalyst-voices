import 'dart:async';

import 'package:catalyst_voices/common/ext/text_editing_controller_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class AccountUsernameTile extends StatefulWidget {
  const AccountUsernameTile({
    super.key,
  });

  @override
  State<AccountUsernameTile> createState() => _AccountUsernameTileState();
}

class _AccountUsernameTileState extends State<AccountUsernameTile> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  bool _isEditMode = false;
  Username _username = const Username.pure();
  StreamSubscription<Username>? _sub;

  @override
  Widget build(BuildContext context) {
    return EditableTile(
      key: const Key('AccountDisplayNameTile'),
      title: context.l10n.displayName,
      onChanged: _onEditModeChange,
      isEditMode: _isEditMode,
      isSaveEnabled: _username.isValid,
      child: VoicesUsernameTextField(
        key: const Key('AccountDisplayNameTextField'),
        controller: _controller,
        focusNode: _focusNode,
        decoration: VoicesTextFieldDecoration(
          hintText: context.l10n.displayName,
          errorText: _username.displayError?.message(context),
        ),
        onFieldSubmitted: null,
        readOnly: !_isEditMode,
        maxLength: _isEditMode ? Username.lengthRange.max : null,
      ),
    );
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
  void initState() {
    super.initState();

    final bloc = context.read<AccountCubit>();
    final text = bloc.state.username.value;
    final value = TextEditingValueExt.collapsedAtEndOf(text);
    _controller = TextEditingController.fromValue(value);
    _controller.addListener(_handleControllerChange);
    _username = bloc.state.username;

    _focusNode = FocusNode();

    _sub = bloc.stream.map((event) => event.username).distinct().listen(_handleUsernameChange);
  }

  void _handleControllerChange() {
    setState(() {
      _username = Username.dirty(_controller.text);
    });
  }

  void _handleUsernameChange(Username displayName) {
    if (_isEditMode) {
      return;
    }

    _controller.textWithSelection = displayName.value;
  }

  void _onCancel() {
    final displayName = context.read<AccountCubit>().state.username;
    _controller.textWithSelection = displayName.value;
  }

  void _onEditModeChange(EditableTileChange value) {
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
          unawaited(_onSave());
      }
    });
  }

  Future<void> _onSave() async {
    final cubit = context.read<AccountCubit>();
    final updated = await cubit.updateUsername(_username);

    if (!updated && mounted) {
      setState(() {
        _username = cubit.state.username;
        _controller.textWithSelection = _username.value;
      });
    }
  }
}
