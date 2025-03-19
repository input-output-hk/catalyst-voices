import 'dart:async';

import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TosRichText extends StatefulWidget {
  const TosRichText({super.key});

  @override
  State<TosRichText> createState() => _TosRichTextState();
}

class _TosRichTextState extends State<TosRichText> with LaunchUrlMixin {
  late final TapGestureRecognizer _recognizer;

  @override
  void initState() {
    super.initState();

    _recognizer = TapGestureRecognizer();
    _recognizer.onTap = () {
      final uri = Uri.parse(VoicesConstants.tosUrl);
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
      context.l10n.createBaseProfileAcknowledgementsToS,
      placeholderSpanBuilder: (context, placeholder) {
        return switch (placeholder) {
          'tos' => TextSpan(
              text: context.l10n.catalystTos,
              recognizer: _recognizer,
              style: const TextStyle(decoration: TextDecoration.underline),
            ),
          _ => throw ArgumentError('Unknown placeholder', placeholder),
        };
      },
    );
  }
}
