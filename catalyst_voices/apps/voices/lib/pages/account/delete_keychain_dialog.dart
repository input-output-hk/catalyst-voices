import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/modals/voices_desktop_dialog.dart';
import 'package:catalyst_voices/widgets/modals/voices_dialog.dart';
import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class DeleteKeychainDialog extends StatefulWidget {
  const DeleteKeychainDialog._();

  @override
  State<DeleteKeychainDialog> createState() => _DeleteKeychainDialogState();

  static Future<bool> show(BuildContext context) async {
    final result = await VoicesDialog.show<bool>(
      context: context,
      routeSettings: const RouteSettings(name: '/delete-keychain'),
      builder: (context) => const DeleteKeychainDialog._(),
    );

    return result ?? false;
  }
}

class _DeleteKeychainDialogState extends State<DeleteKeychainDialog> {
  final _textEditingController = TextEditingController();
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return VoicesSinglePaneDialog(
      backgroundColor: Theme.of(context).colors.iconsBackground,
      showBorder: true,
      constraints: const BoxConstraints(maxHeight: 464, maxWidth: 648),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 36),
            VoicesAssets.icons.x.buildIcon(
              size: 48,
              color: context.colors.iconsError,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.removeKeychainDialogTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 482),
              child: Text(
                context.l10n.removeKeychainDialogSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 25),
            Text(
              context.l10n.deleteKeychainDialogTypingInfo,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 25),
            Wrap(
              direction: Axis.vertical,
              children: [
                Text(
                  context.l10n.deleteKeychainDialogInputLabel,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                SizedBox(
                  width: 300,
                  child: VoicesTextField(
                    key: const Key('DeleteKeychainTextField'),
                    controller: _textEditingController,
                    onFieldSubmitted: _removeKeychain,
                    decoration: VoicesTextFieldDecoration(
                      errorText: _errorText,
                      errorMaxLines: 2,
                      filled: true,
                      fillColor: Theme.of(context)
                          .colors
                          .elevationsOnSurfaceNeutralLv1White,
                      hintText: context.l10n.enterPhrase,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Wrap(
              children: [
                VoicesFilledButton(
                  key: const Key('DeleteKeychainContinueButton'),
                  backgroundColor: Theme.of(context).colors.iconsError,
                  onTap: _removeKeychain,
                  child: Text(context.l10n.continueText),
                ),
                const SizedBox(width: 8),
                VoicesTextButton.danger(
                  onTap: () => Navigator.of(context).pop(),
                  child: Text(context.l10n.cancelButtonText),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      setState(() {
        _errorText = null;
      });
    });
  }

  bool _isDeleteConfirmed(String value) {
    return value == context.l10n.deleteKeychainDialogRemovingPhrase;
  }

  void _removeKeychain([String? value]) {
    if (_isDeleteConfirmed(value ?? _textEditingController.text)) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        _errorText = context.l10n.deleteKeychainDialogErrorText;
      });
    }
  }
}
