import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/banner/voices_banner.dart';
import 'package:catalyst_voices/widgets/rich_text/markdown_text.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class EmailNeedVerificationContributorBanner extends StatelessWidget {
  const EmailNeedVerificationContributorBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PublicProfileEmailStatusCubit, PublicProfileEmailStatusState, bool>(
      selector: (state) {
        return state.showDiscoveryEmailVerificationBanner;
      },
      builder: (context, show) {
        return Offstage(
          offstage: !show,
          child: VoicesBanner(
            child: MarkdownText(
              MarkdownData(
                context.l10n.emailNotVerifiedBannerContributor,
              ),
              pStyle: context.textTheme.labelLarge,
            ),
          ),
        );
      },
    );
  }
}
