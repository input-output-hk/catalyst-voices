import 'dart:async';

import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyRichText extends StatefulWidget {
  const PrivacyPolicyRichText({super.key});

  @override
  State<PrivacyPolicyRichText> createState() => _PrivacyPolicyRichTextState();
}

class _PrivacyPolicyRichTextState extends State<PrivacyPolicyRichText>
    with LaunchUrlMixin {
  late final TapGestureRecognizer _recognizer;

  @override
  void initState() {
    super.initState();

    _recognizer = TapGestureRecognizer();
    _recognizer.onTap = () {
      final uri = Uri.parse(VoicesConstants.privacyPolicyUrl);
      unawaited(launchUri(uri));
    };
  }

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlaceholderRichText(
      context.l10n.createBaseProfileAcknowledgementsPrivacyPolicy,
      placeholderSpanBuilder: (context, placeholder) {
        return switch (placeholder) {
          'privacy_policy' => TextSpan(
              text: context.l10n.catalystPrivacyPolicy,
              recognizer: _recognizer,
              style: const TextStyle(decoration: TextDecoration.underline),
            ),
          _ => throw ArgumentError('Unknown placeholder', placeholder),
        };
      },
    );
  }
}
