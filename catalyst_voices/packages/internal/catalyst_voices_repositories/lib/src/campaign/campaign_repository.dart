import 'package:catalyst_voices_models/catalyst_voices_models.dart';

class CampaignRepository {
  Future<Campaign?> getActiveCampaign() {
    // TODO(dtscalac): replace by api call
    return getCampaign(id: 'F14');
  }

  Future<Campaign> getCampaign({
    required String id,
  }) async {
    final now = DateTime.now();

    const sections = [
      CampaignSection(
        id: '1',
        category: CampaignCategory(id: '1', name: 'Concept'),
        title: 'Introduction',
        body: _tmpBody,
      ),
      CampaignSection(
        id: '2',
        category: CampaignCategory(id: '2', name: 'Product'),
        title: 'Motivation',
        body: 'Different body here\n$_tmpBody',
      ),
    ];

    return Campaign(
      id: id,
      name: 'Boost Social Entrepreneurship',
      description: 'We are currently only decentralizing our technology, '
          'failing to rethink how interactions play out in novel '
          'web3/p2p Action networks.',
      startDate: now.add(const Duration(days: 10)),
      endDate: now.add(const Duration(days: 92)),
      proposalsCount: 0,
      sections: sections,
      publish: CampaignPublish.draft,
      proposalTemplate: const ProposalTemplate(),
    );
  }
}

const _tmpBody = '''
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
learning resource by the rest of the community.''';
