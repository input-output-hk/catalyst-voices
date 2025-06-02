import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_latest_updated.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_order_dropdown.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ProposalsSubHeader extends StatelessWidget {
  const ProposalsSubHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 10,
      children: [
        _TitleText(),
        Spacer(),
        ProposalsLatestUpdated(),
        ProposalsOrderDropdown(),
      ],
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.proposals,
      style: context.textTheme.titleMedium?.copyWith(color: context.colors.textOnPrimary),
    );
  }
}
