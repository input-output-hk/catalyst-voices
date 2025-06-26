import 'dart:async';

import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ConditionsRichText extends StatefulWidget {
  const ConditionsRichText({super.key});

  @override
  State<ConditionsRichText> createState() => _ConditionsRichTextState();
}

class _ConditionsRichTextState extends State<ConditionsRichText> with LaunchUrlMixin {
  late final TapGestureRecognizer _recognizer;

  @override
  Widget build(BuildContext context) {
    return PlaceholderRichText(
      key: const Key('ConditionsRichText'),
      context.l10n.createProfileAcknowledgementsConditions('{conditions}'),
      style: context.textTheme.bodySmall,
      placeholderSpanBuilder: (context, placeholder) {
        return switch (placeholder) {
          'conditions' => TextSpan(
              text: context.l10n.catalystConditions,
              recognizer: _recognizer,
              style: const TextStyle(decoration: TextDecoration.underline),
            ),
          _ => throw ArgumentError('Unknown placeholder', placeholder),
        };
      },
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
      final uri = Uri.parse(VoicesConstants.conditionsUrl);
      unawaited(launchUri(uri));
    };
  }
}
