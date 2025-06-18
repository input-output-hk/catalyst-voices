import 'package:catalyst_voices/widgets/banner/widgets/email_need_verification_contributor_banner.dart';
import 'package:catalyst_voices/widgets/banner/widgets/email_need_verification_proposer_banner.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class EmailNeedVerificationBanner extends StatelessWidget {
  const EmailNeedVerificationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PublicProfileEmailStatusCubit, PublicProfileEmailStatusState, bool>(
      selector: (state) {
        return state.isVisible && !state.isEmailVerified;
      },
      builder: (context, shouldShowBanner) {
        if (!shouldShowBanner) {
          return const SizedBox.shrink();
        }

        return BlocSelector<PublicProfileEmailStatusCubit, PublicProfileEmailStatusState, bool>(
          selector: (state) => state.isProposer,
          builder: (context, isProposer) {
            if (isProposer) {
              return const EmailNeedVerificationProposerBanner();
            } else {
              return const EmailNeedVerificationContributorBanner();
            }
          },
        );
      },
    );
  }
}
