import 'dart:async';

import 'package:catalyst_voices/common/ext/text_editing_controller_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountEmailTile extends StatefulWidget {
  const AccountEmailTile({super.key});

  @override
  State<AccountEmailTile> createState() => _AccountEmailTileState();
}

class _AccountEmailTileState extends State<AccountEmailTile> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  bool _isEditMode = false;
  Email _email = const Email.pure();
  StreamSubscription<Email>? _sub;

  @override
  Widget build(BuildContext context) {
    return EditableTile(
      title: context.l10n.emailAddress,
      key: const Key('AccountEmailTile'),
      onChanged: _onEditModeChange,
      isEditMode: _isEditMode,
      isSaveEnabled: _email.isValid,
      child: VoicesEmailTextField(
        key: const Key('AccountEmailTextField'),
        controller: _controller,
        focusNode: _focusNode,
        decoration: VoicesTextFieldDecoration(
          hintText: context.l10n.emailAddress,
          errorText: _email.displayError?.message(context),
        ),
        onFieldSubmitted: null,
        readOnly: !_isEditMode,
        maxLength: _isEditMode ? Email.lengthRange.max : null,
      ),
    );
  }

  @override
  void dispose() {
    unawaited(_sub?.cancel());
    _sub = null;

    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final bloc = context.read<AccountCubit>();
    final text = bloc.state.email.value;
    final value = TextEditingValueExt.collapsedAtEndOf(text);
    _controller = TextEditingController.fromValue(value);
    _controller.addListener(_handleControllerChange);
    _email = bloc.state.email;

    _focusNode = FocusNode();

    _sub = bloc.stream
        .map((event) => event.email)
        .distinct()
        .listen(_handleEmailChange);
  }

  void _handleControllerChange() {
    setState(() {
      _email = Email.dirty(_controller.text);
    });
  }

  void _handleEmailChange(Email email) {
    if (_isEditMode) {
      return;
    }

    _controller.textWithSelection = email.value;
  }

  void _onCancel() {
    final email = context.read<AccountCubit>().state.email;
    _controller.textWithSelection = email.value;
  }

  void _onEditModeChange(EditableTileChange value) {
    setState(() {
      _isEditMode = value.isEditMode;

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
    final updated = await cubit.updateEmail(_email);

    if (!updated && mounted) {
      setState(() {
        _email = cubit.state.email;
        _controller.textWithSelection = _email.value;
      });
    }
  }
}
