import 'dart:async';

import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TosAndPrivacyPolicyRichText extends StatefulWidget {
  const TosAndPrivacyPolicyRichText({super.key});

  @override
  State<TosAndPrivacyPolicyRichText> createState() => _TosAndPrivacyPolicyRichTextState();
}

class _TosAndPrivacyPolicyRichTextState extends State<TosAndPrivacyPolicyRichText>
    with LaunchUrlMixin {
  late final TapGestureRecognizer _tosRecognizer;
  late final TapGestureRecognizer _privacyPolicyRecognizer;

  @override
  Widget build(BuildContext context) {
    return PlaceholderRichText(
      key: const Key('TosAndPrivacyPolicyRichText'),
      context.l10n.createProfileAcknowledgementsTosAndPrivacyPolicy('{tos}', '{privacy_policy}'),
      style: context.textTheme.bodySmall,
      placeholderSpanBuilder: (context, placeholder) {
        return switch (placeholder) {
          'tos' => TextSpan(
              text: context.l10n.catalystTos,
              recognizer: _tosRecognizer,
              style: const TextStyle(decoration: TextDecoration.underline),
            ),
          'privacy_policy' => TextSpan(
              text: context.l10n.catalystPrivacyPolicy,
              recognizer: _privacyPolicyRecognizer,
              style: const TextStyle(decoration: TextDecoration.underline),
            ),
          _ => throw ArgumentError('Unknown placeholder', placeholder),
        };
      },
    );
  }

  @override
  void dispose() {
    _privacyPolicyRecognizer.dispose();
    _tosRecognizer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _tosRecognizer = TapGestureRecognizer();
    _tosRecognizer.onTap = () {
      final uri = Uri.parse(VoicesConstants.tosUrl);
      unawaited(launchUri(uri));
    };
    _privacyPolicyRecognizer = TapGestureRecognizer();
    _privacyPolicyRecognizer.onTap = () {
      final uri = Uri.parse(VoicesConstants.privacyPolicyUrl);
      unawaited(launchUri(uri));
    };
  }
}
