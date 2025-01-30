import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class AccountEmailTile extends StatelessWidget {
  const AccountEmailTile({super.key});

  @override
  Widget build(BuildContext context) {
    return EditableTile(
      title: 'Email address',
      child: _Tile(
        errorText: const Email.pure().displayError?.message(context),
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
    return VoicesEmailTextField(
      initialText: 'tyler@paperstsoap.com',
      decoration: VoicesTextFieldDecoration(
        hintText: 'Email address',
        errorText: errorText,
      ),
      onFieldSubmitted: null,
      readOnly: true,
      maxLength: Email.lengthRange.max,
    );
  }
}
