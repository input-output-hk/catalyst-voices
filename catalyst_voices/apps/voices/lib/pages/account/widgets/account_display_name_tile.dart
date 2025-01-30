import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class AccountDisplayNameTile extends StatelessWidget {
  const AccountDisplayNameTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return EditableTile(
      title: 'Display Name',
      child: _Tile(
        errorText: const DisplayName.pure().displayError?.message(context),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String? errorText;

  const _Tile({
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesDisplayNameTextField(
      initialText: 'TylerDur99',
      decoration: VoicesTextFieldDecoration(
        hintText: 'Display Name',
        errorText: errorText,
      ),
      onFieldSubmitted: null,
      readOnly: true,
      maxLength: DisplayName.lengthRange.max,
    );
  }
}
