import 'package:catalyst_voices/pages/campaign/details/widgets/campaign_categories_tile.dart';
import 'package:catalyst_voices/pages/campaign/details/widgets/campaign_details_tile.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class CampaignDetailsDialog extends StatefulWidget {
  final String id;

  const CampaignDetailsDialog._({
    required this.id,
  });

  static Future<void> show(
    BuildContext context, {
    required String id,
  }) {
    return VoicesDialog.show(
      context: context,
      routeSettings: RouteSettings(name: '/campaign_${id}_details'),
      builder: (context) => CampaignDetailsDialog._(id: id),
      barrierDismissible: true,
    );
  }

  @override
  State<CampaignDetailsDialog> createState() => _CampaignDetailsDialogState();
}

class _CampaignDetailsDialogState extends State<CampaignDetailsDialog> {
  @override
  Widget build(BuildContext context) {
    return VoicesDetailsDialog(
      title: 'Boost Social Entrepreneurship',
      titleLabel: 'Campaign',
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            final now = DateTime.now();

            return CampaignDetailsTile(
              description:
                  'We are currently only decentralizing our technology, '
                  'failing to rethink how interactions play out in novel '
                  'web3/p2p Action networks.',
              startDate: now.add(const Duration(days: 10)),
              endDate: now.add(const Duration(days: 92)),
              categoriesCount: 2,
              proposalsCount: 0,
            );
          }

          if (index == 1) {
            return CampaignCategoriesTile(
              sections: [
                CampaignSection(
                  id: '1',
                  category: const CampaignCategory(id: '1', name: 'Concept'),
                  title: 'Introduction',
                  body: '''
Open source software, hardware and data solutions encourage 
greater transparency and security, and help reduce costs by 
developing, collaborating, and fixing in the open. 
More information on open source can be found here.  

Cardano Open: Developers category supports developers and 
engineers to contribute to or develop open source technology 
centered around enabling and improving the Cardano developer 
experience. 

The goal of this category is to create developer-friendly 
tooling and approaches that streamline an integrated 
development environment, help to create code more 
efficiently, and provide an ease of use for developers to 
build on Cardano. 

Details of the selected open source license must be 
submitted by the applicants as part of their proposal. 

As part of their deliverables, projects will also be 
required to submit open source, high quality documentation 
for their technology that can be used as a 
learning resource by the rest of the community.'''
                      .trim(),
                ),
                CampaignSection(
                  id: '2',
                  category: const CampaignCategory(id: '2', name: 'Product'),
                  title: 'Motivation',
                  body: '''
Open source software, hardware and data solutions encourage 
greater transparency and security, and help reduce costs by 
developing, collaborating, and fixing in the open. 
More information on open source can be found here.  

Cardano Open: Developers category supports developers and 
engineers to contribute to or develop open source technology 
centered around enabling and improving the Cardano developer 
experience. 

The goal of this category is to create developer-friendly 
tooling and approaches that streamline an integrated 
development environment, help to create code more 
efficiently, and provide an ease of use for developers to 
build on Cardano. 

Details of the selected open source license must be 
submitted by the applicants as part of their proposal. 

As part of their deliverables, projects will also be 
required to submit open source, high quality documentation 
for their technology that can be used as a 
learning resource by the rest of the community.'''
                      .trim(),
                ),
              ],
            );
          }

          throw ArgumentError('too much');
        },
      ),
    );
  }
}
