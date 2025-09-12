import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
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
    return VoicesInfoDialog(
      icon: VoicesAssets.icons.x.buildIcon(color: context.colors.iconsError),
      title: Text(context.l10n.removeKeychainDialogTitle),
      message: Text(
        context.l10n.removeKeychainDialogSubtitle,
        style: const TextStyle(fontWeight: FontWeight.normal),
      ),
      subMessage: Text(
        context.l10n.deleteKeychainDialogTypingInfo,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      action: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 300,
            child: VoicesTextField(
              key: const Key('DeleteKeychainTextField'),
              controller: _textEditingController,
              onFieldSubmitted: _removeKeychain,
              decoration: VoicesTextFieldDecoration(
                labelText: context.l10n.deleteKeychainDialogInputLabel,
                errorText: _errorText,
                errorMaxLines: 2,
                fillColor: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1White,
                hintText: context.l10n.enterPhrase,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            alignment: WrapAlignment.center,
            children: [
              VoicesFilledButton(
                key: const Key('DeleteKeychainContinueButton'),
                backgroundColor: Theme.of(context).colors.iconsError,
                onTap: _removeKeychain,
                child: Text(context.l10n.continueText),
              ),
              VoicesTextButton.danger(
                onTap: () => Navigator.of(context).pop(),
                child: Text(context.l10n.cancelButtonText),
              ),
            ],
          ),
        ],
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
