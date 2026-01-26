import 'dart:async';

import 'package:catalyst_voices/common/ext/text_editing_controller_ext.dart';
import 'package:catalyst_voices/pages/account/widgets/account_public_verification_status_chip.dart';
import 'package:catalyst_voices/pages/account/widgets/account_re_send_verification_button.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class AccountEmailTile extends StatefulWidget {
  const AccountEmailTile({super.key});

  @override
  State<AccountEmailTile> createState() => _AccountEmailTileState();
}

class _AccountEmailTileState extends State<AccountEmailTile> {
  late final TextEditingController _controller;
  late final WidgetStatesController _statesController;
  late final FocusNode _focusNode;

  bool _isEditMode = false;
  Email _email = const Email.pure();
  AccountPublicStatus _accountPublicStatus = AccountPublicStatus.unknown;

  StreamSubscription<Email>? _emailSub;
  StreamSubscription<AccountPublicStatus>? _publicStatusSub;

  @override
  Widget build(BuildContext context) {
    final isVerified = _accountPublicStatus.isVerified;
    final hasEmail = _email.value.isNotEmpty && _email.isValid;

    return EditableTile(
      title: context.l10n.emailAddress,
      key: const Key('AccountEmailTile'),
      onChanged: _onEditModeChange,
      isEditMode: _isEditMode,
      isSaveEnabled: hasEmail,
      statesController: _statesController,
      footerActions: [
        if (!_isEditMode && !isVerified && hasEmail) const AccountReSendVerificationButton(),
      ],
      child: VoicesEmailTextField(
        key: const Key('AccountEmailTextField'),
        controller: _controller,
        focusNode: _focusNode,
        decoration: VoicesTextFieldDecoration(
          hintText: context.l10n.accountEmailHint,
          errorText: _email.displayError?.message(context),
          suffixIcon: Offstage(
            offstage: _isEditMode || _email.value.isEmpty,
            child: const AccountPublicVerificationStatusChip(),
          ),
          helperText: !_isEditMode && !isVerified ? context.l10n.accountEmailVerifyHelper : null,
        ),
        onFieldSubmitted: null,
        readOnly: !_isEditMode,
        maxLength: _isEditMode ? Email.lengthRange.max : null,
      ),
    );
  }

  @override
  void dispose() {
    unawaited(_emailSub?.cancel());
    _emailSub = null;

    unawaited(_publicStatusSub?.cancel());
    _publicStatusSub = null;

    _focusNode.dispose();
    _controller.dispose();
    _statesController.dispose();

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

    _focusNode = FocusNode()..addListener(_handleFocusChange);

    _statesController = WidgetStatesController({
      if (_email.value.isEmpty) WidgetState.error,
      if (_isEditMode) WidgetState.selected,
    });

    _emailSub = bloc.stream.map((event) => event.email).distinct().listen(_handleEmailChange);

    _accountPublicStatus = bloc.state.accountPublicStatus;
    _publicStatusSub = bloc.stream
        .map((event) => event.accountPublicStatus)
        .distinct()
        .listen(_handleAccountPublicStatusChanged);
  }

  void _handleAccountPublicStatusChanged(AccountPublicStatus status) {
    setState(() {
      _accountPublicStatus = status;
    });
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

  void _handleFocusChange() {
    _statesController.update(WidgetState.focused, _focusNode.hasFocus);
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

      final addErrorState = !_isEditMode && _email.value.isEmpty;
      _statesController
        ..update(WidgetState.error, addErrorState)
        ..update(WidgetState.selected, _isEditMode);

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
