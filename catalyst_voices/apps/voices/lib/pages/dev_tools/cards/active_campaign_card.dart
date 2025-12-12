import 'package:catalyst_voices/pages/dev_tools/cards/info_card.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class ActiveCampaignCard extends StatelessWidget {
  const ActiveCampaignCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DevToolsBloc, DevToolsState, DevToolsCampaignState>(
      selector: (state) => state.campaign,
      builder: (context, state) {
        return _ActiveCampaignCard(
          activeCampaign: state.activeCampaign,
          allCampaigns: state.allCampaigns,
        );
      },
    );
  }
}

class _ActiveCampaignCard extends StatelessWidget {
  final Campaign? activeCampaign;
  final List<Campaign> allCampaigns;

  const _ActiveCampaignCard({
    required this.activeCampaign,
    required this.allCampaigns,
  });

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      title: const Text('Campaign'),
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            const Text('Active Campaign'),
            DropdownButton<Campaign>(
              value: activeCampaign,
              hint: const Text('Select a campaign'),
              items: allCampaigns.map((Campaign value) {
                return DropdownMenuItem<Campaign>(
                  value: value,
                  child: Text(value.name),
                );
              }).toList(),
              onChanged: (Campaign? newValue) {
                if (newValue != null) {
                  context.read<DevToolsBloc>().add(ChangeActiveCampaignEvent(newValue));
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
