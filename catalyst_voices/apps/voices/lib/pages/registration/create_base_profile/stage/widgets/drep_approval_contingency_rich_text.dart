import 'dart:async';

import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/common/ext/active_fund_number_selector_ext.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DrepApprovalContingencyRichText extends StatefulWidget {
  const DrepApprovalContingencyRichText({super.key});

  @override
  State<DrepApprovalContingencyRichText> createState() => _DrepApprovalContingencyRichTextState();
}

class _DrepApprovalContingencyRichTextState extends State<DrepApprovalContingencyRichText>
    with LaunchUrlMixin {
  late final TapGestureRecognizer _f14ProposalSubmissionNoticeRecognizer;

  @override
  Widget build(BuildContext context) {
    final fundNumber = context.activeCampaignFundNumber;
    return PlaceholderRichText(
      key: const Key('DrepApprovalContingencyRichText'),
      context.l10n.createProfileDrepApprovalContingency('{fund14ProposalSubmissionNotice}'),
      style: context.textTheme.bodySmall,
      placeholderSpanBuilder: (context, placeholder) {
        return switch (placeholder) {
          'fund14ProposalSubmissionNotice' => TextSpan(
            text: context.l10n.fundProposalSubmissionNotice(fundNumber),
            recognizer: _f14ProposalSubmissionNoticeRecognizer,
            style: const TextStyle(decoration: TextDecoration.underline),
          ),
          _ => throw ArgumentError('Unknown placeholder', placeholder),
        };
      },
    );
  }

  @override
  void dispose() {
    _f14ProposalSubmissionNoticeRecognizer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _f14ProposalSubmissionNoticeRecognizer = TapGestureRecognizer();
    _f14ProposalSubmissionNoticeRecognizer.onTap = () {
      final uri = Uri.parse(VoicesConstants.f14ProposalSubmissionNoticeUrl);
      unawaited(launchUri(uri));
    };
  }
}
