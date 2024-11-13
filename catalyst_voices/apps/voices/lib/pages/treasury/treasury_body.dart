import 'package:catalyst_voices/pages/treasury/treasury_campaign_setup.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class TreasuryBody extends StatelessWidget {
  final List<TreasurySection> sections;

  const TreasuryBody({
    super.key,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 10),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];

        switch (section) {
          case CampaignSetup():
            return TreasuryCampaignSetup(
              key: ValueKey('CampaignSetupSection[${section.id}]Key'),
              data: section,
            );
        }
      },
      separatorBuilder: (context, index) => const SizedBox(height: 24),
    );
  }
}
