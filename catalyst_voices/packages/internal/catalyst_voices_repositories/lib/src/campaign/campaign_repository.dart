import 'package:catalyst_voices_models/catalyst_voices_models.dart';

final class CampaignRepository {
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
      proposalTemplate: ProposalTemplate(
        sections: [
          ProposalSection(
            id: '${id}_1',
            name: 'Proposal Setup',
            steps: [
              ProposalSectionStep(
                id: '${id}_1_1',
                name: 'Title',
                guidances: List.from(_mockGuidance),
              ),
            ],
          ),
          ProposalSection(
            id: '${id}_2',
            name: 'Proposal Summary',
            steps: [
              ProposalSectionStep(
                id: '${id}_2_1',
                name: 'Problem Statement',
                guidances: List.from(_mockGuidance),
              ),
              ProposalSectionStep(
                id: '${id}_2_2',
                name: 'Solution Statement',
                guidances: List.from(_mockGuidance),
              ),
            ],
          ),
          ProposalSection(
            id: '${id}_3',
            name: 'Proposal Setup',
            steps: [
              ProposalSectionStep(
                id: '${id}_3_1',
                name: 'Topic 1',
                guidances: List.from(_mockGuidance),
              ),
              ProposalSectionStep(
                id: '${id}_3_2',
                name: 'Topic 2',
                guidances: List.from(_mockGuidance),
              ),
              ProposalSectionStep(
                id: '${id}_3_3',
                name: 'Topic 3',
                guidances: List.from(_mockGuidance),
              ),
              ProposalSectionStep(
                id: '${id}_3_4',
                name: 'Topic 4',
                guidances: List.from(_mockGuidance),
              ),
            ],
          ),
        ],
      ),
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

const List<Guidance> _mockGuidance = [
  Guidance(
    id: 'g_1',
    title: 'Use a Compelling Hook or Unique Angle',
    description:
        '''Adding an element of intrigue or a unique approach can make your title stand out. For example, “Revolutionizing Urban Mobility with Eco-Friendly Innovation” not only describes the proposal but also piques curiosity.''',
    type: GuidanceType.tips,
    weight: 1,
  ),
  Guidance(
    id: 'g_1',
    title: 'Be Specific and Solution-Oriented',
    description:
        '''Use keywords that pinpoint the problem you’re solving or the opportunity you’re capitalizing on. A title like “Streamlining Supply Chains for Cost-Effective and Rapid Delivery” instantly tells the reader what the proposal aims to achieve.''',
    type: GuidanceType.mandatory,
    weight: 2,
  ),
  Guidance(
    id: 'g_1',
    title: 'Highlight the Benefit or Outcome',
    description:
        '''Make sure the reader can immediately see the value or the end result of your proposal. A title like “Boosting Engagement and Growth through Targeted Digital Strategies” puts the focus on the positive outcomes.''',
    type: GuidanceType.mandatory,
    weight: 1,
  ),
  Guidance(
    id: 'g_1',
    title: 'Education',
    description: 'Use keywords that pinpoint the problem yo',
    type: GuidanceType.education,
    weight: 1,
  ),
];
