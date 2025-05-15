import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class PickUsernameDialog extends StatefulWidget {
  const PickUsernameDialog._();

  @override
  State<PickUsernameDialog> createState() => _PickUsernameDialogState();

  static Future<String?> show(BuildContext context) {
    return VoicesDialog.show(
      context: context,
      builder: (_) => const PickUsernameDialog._(),
      routeSettings: const RouteSettings(name: '/pick-username'),
    );
  }
}

class _PickUsernameDialogState extends State<PickUsernameDialog> {
  Username _username = const Username.pure();

  @override
  Widget build(BuildContext context) {
    return VoicesSinglePaneDialog(
      child: FractionallySizedBox(
        widthFactor: 0.65,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 44),
            Text(
              context.l10n.commentPickUsername,
              style:
                  context.textTheme.titleLarge?.copyWith(color: context.colors.textOnPrimaryLevel0),
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.commentPickUsernameLabel,
              style:
                  context.textTheme.bodyMedium?.copyWith(color: context.colors.textOnPrimaryLevel0),
            ),
            const SizedBox(height: 24),
            VoicesUsernameTextField(
              onFieldSubmitted: _trySubmitValue,
              onChanged: _updateAndValidate,
              decoration: VoicesTextFieldDecoration(
                labelText: context.l10n.commentPickUsername,
                hintText: context.l10n.commentPickUsernameHint,
                errorText: _username.displayError?.message(context),
              ),
              maxLength: Username.lengthRange.max,
            ),
            const SizedBox(height: 24),
            VoicesFilledButton(
              onTap: _username.isValid ? _submit : null,
              child: Text(context.l10n.confirm),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _submit() {
    Navigator.pop(context, _username.value);
  }

  void _trySubmitValue(String value) {
    setState(() {
      _updateUsername(value);

      if (_username.isValid) {
        Navigator.pop(context, _username.value);
      }
    });
  }

  void _updateAndValidate(String? value) {
    setState(() {
      _updateUsername(value);
    });
  }

  void _updateUsername(String? value) {
    _username = Username.dirty(value ?? '');
  }
}
