import 'package:catalyst_voices/pages/registration/widgets/registration_confirm_dialog.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExportCatalystKeyConfirmDialog extends StatefulWidget {
  const ExportCatalystKeyConfirmDialog._();

  @override
  State<ExportCatalystKeyConfirmDialog> createState() {
    return _ExportCatalystKeyConfirmDialogState();
  }

  static Future<bool> show(BuildContext context) {
    return VoicesQuestionDialog.show(
      context,
      routeSettings: const RouteSettings(name: '/export-catalyst-key'),
      builder: (_) => const ExportCatalystKeyConfirmDialog._(),
    );
  }
}

class _ExportCatalystKeyConfirmDialogState
    extends State<ExportCatalystKeyConfirmDialog> with LaunchUrlMixin {
  late final TapGestureRecognizer _recognizer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return RegistrationConfirmDialog(
      title: context.l10n.warning,
      subtitle: l10n.createKeychainSeedPhraseExportConfirmDialogSubtitle,
      content: PlaceholderRichText(
        l10n.createKeychainSeedPhraseExportConfirmDialogContent,
        placeholderSpanBuilder: (context, placeholder) {
          return switch (placeholder) {
            'link' => TextSpan(
                text: l10n.bestPracticesFAQ,
                recognizer: _recognizer,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            _ => throw ArgumentError()
          };
        },
      ),
      negativeText: l10n.cancelButtonText,
      positiveText: l10n.exportKey,
    );
  }

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _recognizer = TapGestureRecognizer();
    _recognizer.onTap = () {
      // TODO(damian-molinski): open url when available
    };
  }
}
