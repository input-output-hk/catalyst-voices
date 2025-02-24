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

  static Future<bool> show(BuildContext context) async {
    final result = await VoicesDialog.show<bool>(
      context: context,
      routeSettings: const RouteSettings(name: '/delete-keychain'),
      builder: (context) => const DeleteKeychainDialog._(),
    );

    return result ?? false;
  }

  @override
  State<DeleteKeychainDialog> createState() => _DeleteKeychainDialogState();
}

class _DeleteKeychainDialogState extends State<DeleteKeychainDialog> {
  final _textEditingController = TextEditingController();
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      setState(() {
        _errorText = null;
      });
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VoicesSinglePaneDialog(
      backgroundColor: Theme.of(context).colors.iconsBackground,
      showBorder: true,
      constraints: const BoxConstraints(maxHeight: 500, maxWidth: 900),
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text(
                context.l10n.deleteKeychainDialogTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 48),
              Text(
                context.l10n.deleteKeychainDialogSubtitle,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Wrap(
                children: [
                  VoicesAssets.icons.exclamation.buildIcon(
                    color: Theme.of(context).colors.iconsError,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2, left: 8),
                    child: Text(
                      context.l10n.deleteKeychainDialogWarning,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.deleteKeychainDialogWarningInfo,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Text(
                context.l10n.deleteKeychainDialogTypingInfo,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 24),
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
                      controller: _textEditingController,
                      onFieldSubmitted: _removeKeychain,
                      decoration: VoicesTextFieldDecoration(
                        errorText: _errorText,
                        errorMaxLines: 2,
                        filled: true,
                        fillColor: Theme.of(context)
                            .colors
                            .elevationsOnSurfaceNeutralLv1White,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Wrap(
                children: [
                  VoicesFilledButton(
                    backgroundColor: Theme.of(context).colors.iconsError,
                    onTap: _removeKeychain,
                    child: Text(context.l10n.delete),
                  ),
                  const SizedBox(width: 8),
                  VoicesTextButton.danger(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text(context.l10n.cancelButtonText),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

  bool _isDeleteConfirmed(String value) {
    return value == context.l10n.deleteKeychainDialogRemovingPhrase;
  }
}
