import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/routes/routing/account_route.dart';
import 'package:catalyst_voices/widgets/banner/voices_banner.dart';
import 'package:catalyst_voices/widgets/rich_text/markdown_text.dart';
import 'package:catalyst_voices/widgets/rich_text/placeholder_rich_text.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class EmailNeedVerificationProposerBanner extends StatefulWidget {
  const EmailNeedVerificationProposerBanner({super.key});

  @override
  State<EmailNeedVerificationProposerBanner> createState() =>
      _EmailNeedVerificationProposerBannerState();
}

class _EmailNeedVerificationProposerBannerState extends State<EmailNeedVerificationProposerBanner> {
  late final TapGestureRecognizer _recognizer;
  @override
  Widget build(BuildContext context) {
    return BlocSelector<PublicProfileEmailStatusCubit, PublicProfileEmailStatusState, bool>(
      selector: (state) {
        return state.showProposerEmailVerificationBanner;
      },
      builder: (context, state) {
        return Offstage(
          offstage: !state,
          child: VoicesBanner(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MarkdownText(
                  MarkdownData(
                    context.l10n.emailNotVerifiedBannerProposer,
                  ),
                  pStyle: context.textTheme.labelLarge,
                ),
                PlaceholderRichText(
                  context.l10n.goToMyAccountForEmailVerification('{destination}').withPrefix('- '),
                  placeholderSpanBuilder: (context, placeholder) {
                    return switch (placeholder) {
                      'destination' => TextSpan(
                          text: context.l10n.myAccount,
                          recognizer: _recognizer,
                          style: context.textTheme.labelLarge?.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      _ => throw ArgumentError('Unknown placeholder[$placeholder]'),
                    };
                  },
                ),
              ],
            ),
          ),
        );
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
      unawaited(const AccountRoute().push(context));
    };
  }
}
