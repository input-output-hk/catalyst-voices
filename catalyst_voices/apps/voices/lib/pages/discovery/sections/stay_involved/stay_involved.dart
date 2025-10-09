import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/discovery/sections/stay_involved/widgets/reviewer_card.dart';
import 'package:catalyst_voices/pages/discovery/sections/stay_involved/widgets/voter_card.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class StayInvolved extends StatelessWidget {
  const StayInvolved({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsivePadding(
      xs: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      sm: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
      md: const EdgeInsets.symmetric(horizontal: 120, vertical: 72),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(),
          SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              VoterCard(),
              ReviewerCard(),
            ],
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.stayInvolved,
      style: context.textTheme.headlineMedium,
    );
  }
}
