import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

/// List of static [CampaignCategory] definitions.
///
/// Categories will come from documents later.
///
/// See [CampaignCategory].
final f15StaticCampaignCategories = <CampaignCategory>[
  //Tier-1 Enterprise Integrations
  CampaignCategory(
    id: f15ConstDocumentsRefs[0].category,
    campaignRef: Campaign.f15Ref,
    categoryName: 'Cardano Partners:',
    categorySubname: 'Tier-1 Enterprise Integrations',
    description:
        '''To fund high-impact R&D pilots and integrations led by or in collaboration with established Tier-1 enterprises, driving mainstream Cardano adoption and creating significant co-marketing opportunities.''',
    shortDescription:
        'To fund high-impact R&D pilots and integrations led by or in collaboration with established Tier-1 enterprises, driving mainstream Cardano adoption and creating significant co-marketing opportunities.',
    availableFunds: MultiCurrencyAmount.single(Currencies.ada.amount(10000000)),
    range: Range(
      min: Currencies.ada.amount(250000),
      max: Currencies.ada.amount(750000),
    ),
    currency: Currencies.ada,
    descriptions: const [
      CategoryDescription(
        title: 'Overview',
        description: '''
Cardano Partners: Tier-1 Enterprise Integrations is designed to forge strategic alliances between the Cardano ecosystem and the world's leading organizations. This specialized funding category will support ambitious proposals that implement and pilot Cardano-based solutions to solve real-world challenges for industry giants.

In this category, a “demonstrator pilot” means a time limited project testing the feasibility of an industrial use-case in close collaboration with a Tier 1 enterprise partner. 

Unlike other categories, this category is exclusively for established businesses and collaborations with large-scale organizations prepared to integrate Cardano's utility into their operations. The goal is to generate high-value, high-visibility use cases that demonstrate the power of Cardano at an enterprise level and accelerate mainstream adoption.
''',
      ),
      CategoryDescription(
        title: 'Areas of Interest',
        description: '''
Proposals should focus on mature R&D for products with Tier-1 collaborations, such as:

* **Enterprise integrations:** Demonstrator pilots with Tier-1 industry leaders, e.g. embedding Cardano wallets in automotive systems.
* **Stablecoin use-cases:** Partner-led pilots that show Cardano stablecoins in action supporting real transactions, utility, or payments on Cardano.
* **Scaling solutions:** Maturing use cases using Cardano scaling solutions like Hydra, e.g. a high-throughput payment system for a household-name e-commerce marketplace.
* **Exponential technologies:** Applications leveraging technologies like AI, e.g. an AI-enhanced supply chain solution with a large manufacturer.
* **Compliance solutions:** Solutions to support ADA transactions that have regulatory implications.
* **Growth programs:** Programs that accelerate the investor readiness of founders leveraging Cardano technology.
* **Tokenization platforms:** Tokenized asset platforms with a clear path to validated transaction growth.
''',
      ),
      CategoryDescription(
        title: 'Core Eligibility: Who Can Apply?',
        description: r'''
This category is exclusively for established organizations ready to build on Cardano at scale. To be eligible, the lead applicant must meet all the following criteria. Proposals that do not meet these foundational requirements will not be considered.

* **Be a Registered Business:** You must be a registered legal business entity. Proposals from individuals or unregistered entities will not be accepted.
* **Have a Proven Track Record:** The lead applicant must be an established business with a minimum of a 2-year operational history. The applying consortium (i.e., the lead applicant and its named Tier-1/collaboration partners) must collectively demonstrate verifiable annual revenue of at least \$5M USD in the last fiscal year.
* **Have a Confirmed Tier-1 Partnership:** The lead applicant must be either the Tier-1 enterprise itself (definition further below) or a consortium partner with a formal collaboration agreement (e.g., Letter of Intent, MOU) with a qualified Tier-1 enterprise. This category will not fund feature updates/upgrades to existing on chain products in isolation without a partnership.
* **Maintain Good Standing with Catalyst:** The lead proposer and all named team members must be in full compliance with commitments for any previously funded Catalyst projects. Proposers can verify their compliance status by reviewing their reporting dashboard on the Project Catalyst platform. All milestone reports for previously funded projects must be submitted and approved on time prior to this fund's submission. [Learn more about it here](https://forum.cardano.org/t/submitting-a-proposal-in-upcoming-fund15-read-this-first/149527).

### Defining a "Tier-1 Enterprise"

An organization is considered "Tier-1" if it qualifies under **one** of the following pathways:

1. The partner must meet the following criteria:
   - Verifiably generates \$5M USD or more in annual revenue on their own or in aggregate as a consortium.
   - Demonstrates significant market reach through a substantial national or international customer base, or a widely adopted digital product or service.

2. Or the partner must be:
   - A national government body, a state/county-level agency, or an internationally operating NGO with significant public recognition (e.g. a national health service, a major university).

3. Or the partner must:
   - Provide clear evidence of being a top-tier leader by market share within a significant national or international industry.
''',
      ),
      CategoryDescription(
        title: 'Proposal Requirements',
        description: '''
All proposals submitted to this category must adhere to the following project and content standards. Moderation will be based on these criteria.

- **Focus on integration and growth, not ideas:** Proposals must be for mature R&D demonstrator pilots or direct integrations. Early-stage concepts, prototypes, core Cardano infrastructure, or developer tooling proposals are out of scope.
- **Demonstrate a mature product & integration path:** Applicants must provide documentary  evidence of a mature, deployed product according to one of the following two scenarios:
   1. **Cardano-native product:** The product is already deployed and operational on the Cardano mainnet.
   2. **Cross-ecosystem product:** The product is deployed and operational on another blockchain or ecosystem and is seeking integration with Cardano. The proposal must provide evidence of the existing product *and* a clear integration plan, including a confirmed integration partner or demonstrated in-house capability to execute it.
- **Verify Partnership:** Evidence of the Tier-1 collaboration (e.g. signed letter of intent) must be emailed to the Catalyst team no later than the start of the Community Review in Fund15. This partnership must be declared high level including its role in the public proposal as well. This category is not for product enhancements or feature improvements in isolation. For those - submit under “Cardano use Cases: Prototype And Launch” category instead.
- **Justify On-Chain Transaction Impact:** The proposal's core proposition must include  a clear and compelling explanation of how the project will drive meaningful on-chain transaction volume for Cardano. Applicants must articulate why their solution requires a blockchain and how its implementation on Cardano will directly lead to a verifiable increase in network activity.
- **Define measurable outcomes:** The proposal must include clear, measurable adoption outcomes, with a mandatory forecast for projected on-chain transaction volume. Other KPIs (e.g. user growth, tokenized asset value) are also required.
- **Set a clear timeline:** The project delivery timeline must not exceed 12 months and must be broken down into clear milestones.
- **Show partner commitment:** The proposal must include a clear statement of the partner/enterprise's funding or in-kind contributions to the project.
- **Amplify Cardano:** A plan for co-marketing, public relations, or community engagement must be included to maximize Cardano's visibility.
- **Detail verifiable team credentials:** Simply listing names and roles is insufficient. The proposal must include verifiable references (e.g. comprehensive LinkedIn profiles, project portfolios, public repositories, corporate bios) that clearly demonstrate each key team member's specific experience, accomplishments, and suitability for their role in the project.
- **Identify all partners:** All collaborating entities, including the specific Tier-1 partner and any integration partners, must be clearly named within the proposal.
- **Propose forward-looking work:** Funds are exclusively for future development and project execution. Proposals seeking retroactive funding for work already completed will not be eligible.
- **Detailed Use of Funds:** Proposals must provide a clear budget. Your budget must be for future activities only and allocated exclusively to the project's execution. Proposals seeking retroactive funding are not eligible. Funds cannot be used for purchasing digital assets, providing liquidity, local treasuries, speculation, or simple branded merchandise. Proposals involving re-granting or incentives/giveaways are not eligible either. Please review [Fund Rules](https://docs.projectcatalyst.io/current-fund/fund-basics/fund-rules) for further details in addition to these.
''',
      ),
      CategoryDescription(
        title: 'Self-Assessment Checklist',
        description: r'''
Use this checklist to ensure your proposal meets all foundational and content requirements before submission.

| **Rule & Check** | **Description** |
|:----------|:----------|
| **Legal Entity** | Lead applicant is a verified legal business entity. |
| **Track Record & Revenue** | Lead org has a ≥2-year track record, and the consortium collectively has ≥\$5M in verifiable annual revenue. |
| **Tier-1 Collaboration** | Evidence of collaboration with a qualified Tier-1 enterprise is provided. |
| **Catalyst Standing** | Proposer and all team members are in good standing with prior Catalyst projects. |
| **Scope Fit** | Proposal is for mature R&D or integration, not an early-stage concept or core infrastructure. |
| **Mature Product & Path** | Evidence of a mature product is provided, with a clear integration plan if not already on Cardano. |
| **Partner Identification** | All key partners, including the Tier-1 collaborator, are clearly identified. |
| **Partner Commitment** | A clear statement of the partner's in-kind or financial contributions is included. |
| **Verifiable Credentials** | Proposal provides verifiable references (e.g., LinkedIn, portfolio) for key team members. |
| **Measurable Adoption** | Proposal includes clear KPIs for adoption (e.g., transaction volume, user growth). Forecast for projected on-chain transaction volume is provided with adequate justification. |
| **Timeline** | Delivery is ≤ 12 months with clear milestones. |
| **Visibility & Engagement** | Includes a co-marketing or community engagement plan to amplify Cardano's visibility. |
| **Budget Compliance** | The proposal budget is for future work only, not for completed tasks. No incentives, giveaways, private treasuries and regranting are included in the budget. |
''',
      ),
    ],
    dos: const [
      'Show proof of Tier-1 partnership.',
      r'Show >$5M revenue & 2-yr record.',
      'Propose an integration-ready product.',
      'Define clear KPIs for adoption.',
    ],
    donts: const [
      'Apply as an individual, only businesses.',
      'Propose early-stage ideas or concepts.',
      'Miss the partnership proof deadline.',
      'Use vague team bios; provide links.',
    ],
    submissionCloseDate: DateTimeExt.now(),
    imageUrl: '',
  ),

  //Cardano Use Cases: Prototype & Launch
  CampaignCategory(
    id: f15ConstDocumentsRefs[1].category,
    campaignRef: Campaign.f15Ref,
    categoryName: 'Cardano Use Cases:',
    categorySubname: 'Prototype & Launch',
    description:
        '''To provide entrepreneurial individuals and teams with funding to build and launch novel prototypes that have already undergone foundational research and design, accelerating the delivery of new on-chain utility for Cardano.''',
    shortDescription:
        'To provide entrepreneurial individuals and teams with funding to build and launch novel prototypes that have already undergone foundational research and design, accelerating the delivery of new on-chain utility for Cardano.',
    availableFunds: MultiCurrencyAmount.single(Currencies.ada.amount(6000000)),
    range: Range(
      min: Currencies.ada.amount(15000),
      max: Currencies.ada.amount(200000),
    ),
    currency: Currencies.ada,
    descriptions: const [
      CategoryDescription(
        title: 'Overview',
        description: '''
  This category is dedicated to funding the technical creators who build the Cardano ecosystem. We’re looking for entrepreneurial teams and engineers, experienced blockchain developers both - native or new to Cardano - and small, agile teams who have an idea for a new on-chain utility and the skills to build it. This fund allows builders to scope a project from its initial validated design through to a functional prototype or application deployed on testnet or mainnet. The primary goal is to achieve a public launch of the prototype on a Cardano testnet or mainnet for testing and feedback, not necessarily a full commercial launch with a completed business model.
  ''',
      ),
      CategoryDescription(
        title: 'Areas of Interest',
        description: '''
Proposals should focus on:

- Industrial or commercial use cases with significant potential adoption using Cardano's blockchain and smart contracts.
- DeFi solutions with unique approaches e.g. a peer-to-peer yield and novel bond curve protocol MVP.
- Privacy, oracles, or zero-knowledge proof applications.
- Projects porting or bridging from other ecosystems e.g. a wallet prototyping Cardano Native Token support.
- Prototyping on Cardano scaling solutions like Hydra e.g. a high-throughput payment prototype.
- Prototyping new substantial features to existing on chain products extending their usage.
''',
      ),
      CategoryDescription(
        title: 'Core Eligibility: Who Can Apply?',
        description: '''
This category is for the builders. It is open to individuals and technical teams. To be eligible, you must meet the following criteria:

- **Demonstrate Foundational Work:** Your project must be past the idea stage. You must provide evidence of prior work, such as user research, whitepaper, UX/UI mockups, technical diagrams, or a proof-of-concept.
- **Possess Verifiable Technical Skills:** Proposers must demonstrate the technical capability to deliver the project. This can be verified in one of two ways:
   1. **In-House Talent:** The proposal provides verifiable credentials (e.g., public code repositories, project portfolios) for the core team members who will be building the software.
   2. **Confirmed Development Partner:** The proposal clearly identifies a development partner or agency by name, providing links to their prior work, and includes evidence of the collaboration (e.g., a Letter of Intent or scope of work document).
- **Maintain Good Standing with Catalyst:** The lead proposer and all named team members must be in full compliance with commitments for any previously funded Catalyst projects. Proposers can verify their compliance status by reviewing their reporting dashboard on the Project Catalyst platform. All milestone reports for previously funded projects must be submitted and approved on time prior to this fund's submission. [Learn more about it here.](https://forum.cardano.org/t/submitting-a-proposal-in-upcoming-fund15-read-this-first/149527)
''',
      ),
      CategoryDescription(
        title: 'Proposal Requirements',
        description: '''
All proposals must adhere to the following standards. The primary focus is on turning a validated concept into a tangible, working piece of software - a prototype on Cardano's testnet or mainnet.

- **Define the Problem & Use Case:** Clearly define the problem you are solving and why your on-chain utility is valuable for Cardano users. Explain the ‘So What’ of your proposed solution. This must include a thorough analysis of the existing ecosystem. The responsibility to conduct this research lies entirely with the proposer. Your analysis must specifically address:
  1. **Ecosystem Research:** Describe the results of your research into previously funded projects (via Project Catalyst) and existing solutions in the wider Cardano ecosystem. 
  2. **Value Proposition:** Based on your research findings, demonstrate your project's value in one of two ways:

     a. **If similar solutions exist:** Justify why your proposal is sufficiently unique, detailing how it substantially differs from, improves upon, or builds on them.
	  
     b. **If the solution is novel:** State clearly that no direct precedent was found and explain why introducing this new capability is a valuable and strategic addition to the Cardano ecosystem.
	  
- **Deliver a Functional Prototype:** The primary goal of your project must be a working software prototype deployed on at least a public Cardano testnet that users can interact with. Non-technical projects (e.g., marketing, events) or foundational research only are not eligible. These can be submitted via *"Cardano Open: Ecosystem"* instead.
- **Detail Verifiable Team Credentials:** Simply listing names and roles is insufficient. The proposal must include verifiable references (e.g., comprehensive LinkedIn profiles, project portfolios, public repositories) that clearly demonstrate each key team member's specific experience, accomplishments, and suitability for their role in the project.
- **Outline a Credible Technical Plan:** Describe your technical approach, including the architecture and key technologies you will use.
- **Propose a Realistic Scope:** The budget and timeline (maximum 12 months) must be realistic for delivering the proposed prototype.
- **Justify On-Chain Transaction Impact:** The proposal's core proposition must include a clear and compelling explanation of how the project will drive meaningful on-chain transaction volume for Cardano. Applicants must articulate why their solution requires a blockchain and how its implementation on Cardano will directly lead to a verifiable increase in network activity once launched.
- **Plan for Community Engagement & Feedback:** Instead of a formal marketing plan, outline how you will engage with the Cardano community to get your prototype into the hands of early users. Describe your plan to gather, analyze, and potentially iterate on user feedback.
- **Detailed Use of Funds:** Proposals must provide a clear budget. Your budget must be for future activities only and allocated exclusively to the project's execution. Proposals seeking retroactive funding are not eligible. Funds cannot be used for purchasing digital assets, providing liquidity, local treasuries, speculation, or simple branded merchandise. Proposals involving re-granting or incentives/giveaways are not eligible either. Please review [Fund Rules](https://docs.projectcatalyst.io/current-fund/fund-basics/fund-rules) for further details in addition to these.
''',
      ),
      CategoryDescription(
        title: 'Self-Assessment Checklist',
        description: '''
Use this checklist to ensure your proposal meets all foundational and content requirements before submission.

| **Rule & Check** | **Description** |
|:--------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Foundational Work** | Evidence of prior research, whitepaper, design, or proof-of-concept is provided. |
| **Ecosystem Value Proposition** | The proposal includes ecosystem research and uses the findings to either (a) justify its uniqueness over existing solutions or (b) demonstrate the value of its novel approach. |
| **Builder Credentials** | Demonstrates technical capability via verifiable in-house talent or a confirmed development partner (GitHub, LinkedIn, portfolio, etc.) |
| **Catalyst Standing** | Proposer and all team members are in good standing with prior Catalyst projects. |
| **Problem & Use Case** | The proposal clearly defines the problem and the value of the on-chain utility. |
| **Tangible Prototype** | The primary goal is a working prototype deployed on at least a Cardano testnet. |
| **Technical Approach** | The proposal outlines a credible and clear technical plan and architecture. |
| **Realistic Scope** | The budget and timeline (≤ 12 months) are realistic for the proposed work. |
| **Community Engagement** | Includes a community engagement and feedback plan to amplify prototype adoption with the Cardano ecosystem. |
| **Budget Compliance** | The budget is for future development only; excludes retroactive funding, incentives, giveaways, re-granting, or sub-treasuries. |
''',
      ),
    ],
    dos: const [
      'Show prior work (research, designs).',
      'Deliver a working software prototype.',
      'Provide verifiable tech skills (GitHub).',
      'Solve a clear, well-defined problem.',
    ],
    donts: const [
      "Submit 'idea only' proposals.",
      'Propose marketing or event projects.',
      'Use vague team bios; link your work.',
      'Budget for giveaways/re-grants.',
    ],
    submissionCloseDate: DateTimeExt.now(),
    imageUrl: '',
  ),
  //   //Cardano Open: Ecosystem
  CampaignCategory(
    id: f15ConstDocumentsRefs[2].category,
    campaignRef: Campaign.f15Ref,
    categoryName: 'Cardano Open:',
    categorySubname: 'Ecosystem',
    description:
        '''Funds non-technical initiatives like marketing, education, research, and community building to grow Cardano’s ecosystem and onboard new users globally.''',
    shortDescription:
        'Funds non-technical initiatives like marketing, education, research, and community building to grow Cardano’s ecosystem and onboard new users globally.',
    availableFunds: MultiCurrencyAmount.single(Currencies.ada.amount(2500000)),
    range: Range(
      min: Currencies.ada.amount(15000),
      max: Currencies.ada.amount(60000),
    ),
    currency: Currencies.ada,
    descriptions: const [
      CategoryDescription(
        title: 'Overview',
        description: '''
  This category focuses on building the creative capacity of our passionate global community. It will fund non-technical initiatives that drive grassroots ecosystem growth, education, research and community engagement to broaden Cardano’s reach and on chain adoption. The goal is to support local and global campaigns that bring awareness and attention to Cardano from the hearts and minds of the community collective.
  ''',
      ),
      CategoryDescription(
        title: 'Areas of Interest',
        description: '''
Proposals may focus on non-technical initiatives, such as:

- **Cardano Community Hubs:** Creating or maintaining a local Cardano presence in cities or regions worldwide.
- **Community Events:** Organizing community hackathons or builder outreach events.
- **Content Creation:** Producing educational videos, articles, or tutorials on Cardano's features.
- **Mentorship & Skill-Sharing:** Organizing workshops or programs that connect experienced community members with newcomers to share skills in marketing, content creation, or project management within the Cardano ecosystem.
- **Educational Advancements:** Developing a university course or workshop with Cardano case studies.
- **Local Advocacy:** Authoring a policy paper on Cardano's role in regional finance for local authorities.
- **Research:** Producing a whitepaper, litepaper, or other foundational research to advance a body of knowledge related to Cardano.
''',
      ),
      CategoryDescription(
        title: 'Core Eligibility: Who Can Apply?',
        description: '''
This category is for the community builders: educators, marketers, content creators, and event organizers. To be eligible, you must meet the following criteria:

- **Non-Technical Focus:** You must be proposing a non-technical project. If your proposal focuses on software or hardware development, please apply to a different category. You may not allocate more than 20% of your budget towards supporting technical development work needed to execute your proposal. For clarity, 'technical development work' refers to activities like software programming, smart contract creation, or hardware engineering. It does not typically include routine project-support activities such as building a basic informational website, graphic design, or video production for your content.
- **Demonstrate Relevant Experience:** You must provide verifiable proof of the skills needed to deliver the project. Simply listing names and roles is not enough. Evidence must be provided in the proposal (e.g., a portfolio of past campaigns, links to created content, or reports from previous events).
- **Maintain Good Standing with Catalyst:** The lead proposer and all named team members must be in full compliance with commitments for any previously funded Catalyst projects. Proposers can verify their compliance status by reviewing their reporting dashboard on the Project Catalyst platform. All milestone reports for previously funded projects must be submitted and approved on time prior to this fund's submission. [Learn more about it here.](https://forum.cardano.org/t/submitting-a-proposal-in-upcoming-fund15-read-this-first/149527)
''',
      ),
      CategoryDescription(
        title: 'Proposal Requirements',
        description: '''
All proposals must adhere to the following standards for community-focused initiatives.

- **Define Clear Goals & KPIs:** You must clearly articulate your goals and how you will measure success using Key Performance Indicators (KPIs). Strong proposals will focus on action-oriented metrics (e.g., 'number of articles published,' 'new active members in a community hub,' or 'attendees who complete a workshop') over passive metrics (e.g., 'social media impressions').
- **Demonstrate Community Value:** The proposal must explain how the initiative will grow Cardano's ecosystem, expand its global footprint, or onboard new users. Proposals without clear demonstration of value will be deemed ineligible.
- **Demonstrate Pathway to Adoption:** Applicants must articulate a credible and logical pathway showing how their non-technical initiative encourages and enables future on-chain activity. Instead of requiring direct, immediate attribution for transactions, this should explain how the project moves participants or consumers of the content through the adoption funnel - from awareness and education to direct engagement with the Cardano ecosystem.
   - Strong proposals will:
      1. **Identify a Target Action:** Clearly state the ultimate on-chain action(s) you are preparing users for (e.g., creating a first wallet, minting an NFT on a specific platform, staking ADA, or interacting with a DeFi dApp).
      2. **Map the User Journey:** Describe the steps a new user would take from discovering your content/event to being capable of performing that target action.
- **Provide a "Call to Action":** Explain how your project provides clear, compelling, and actionable next steps. This could be a link to a wallet guide, a tutorial on staking, or a direct introduction to a dApp. Your project should lower the barrier to entry for these actions.
- **Detail Verifiable Team Credentials:** Simply listing names and roles is insufficient. The proposal must include verifiable references (e.g., comprehensive LinkedIn profiles, project portfolios, public repositories) that clearly demonstrate each key team member's specific experience, accomplishments, and suitability for their role in the project.
- **Set a Realistic Timeline:** The project delivery timeline must not exceed 12 months and must include clear milestones for key activities.
- **Commit to Public Outputs:** Proposals must commit to making outputs (e.g., educational content, event reports, research papers) publicly accessible. If any outputs are intended to remain private, a clear justification must be provided.
- **Detail a Compliant Budget:** Your budget must be for future activities only and allocated exclusively to the project's execution. Proposals seeking retroactive funding are not eligible. Funds may not be used for:
   - User incentives, ADA or token giveaways, unless part of an approved hackathon or bounty program with clear governance structure in place how these are administered to avoid misuse.
   - Creating sub-treasuries or re-granting funds.
   - Primarily for merchandise. For proposals involving events, merchandise should be a supporting element and not constitute a significant portion of the budget (e.g., typically not to exceed 15% of the total requested funds).
   - Funds cannot be used for purchasing digital assets, providing liquidity or used in other financial instruments.
   - Please review [Fund Rules](https://docs.projectcatalyst.io/current-fund/fund-basics/fund-rules) for further details in addition to above.
''',
      ),
      CategoryDescription(
        title: 'Self-Assessment Checklist',
        description: '''
Use this checklist to ensure your proposal meets all foundational and content requirements before submission.

| **Rule & Check** | **Description** |
|:----------|:----------|
| **Scope Fit** | Proposal is a non-technical initiative, with ≤20% of the budget for tech support. |
| **Relevant Experience** | Provides verifiable evidence (portfolio, links, reports) of the team's ability to deliver the project. |
| **Catalyst Standing** | Proposer and all team members are in good standing with prior Catalyst projects. |
| **Clear Goals & KPIs** | Includes clear objectives with both Output Metrics (what proposal did) and Adoption-Focused Metrics (what effect proposal had). |
| **Pathway to Adoption** | The proposal clearly explains the user journey and provides a credible plan for how the project will equip and motivate users for future on-chain activity. |
| **Community Value** | The initiative clearly demonstrates how it will grow the Cardano ecosystem or onboard users. |
| **Realistic Timeline** | The project plan and timeline (≤ 12 months) are realistic and well-defined. |
| **Public Outputs** | Commits to public outputs and justifies any exceptions. |
| **Budget Compliance** | The budget adheres to all policies: it is for future work, follows the merchandise rule, and excludes establishing local treasuries, incentives/giveaways, re-grants. |
''',
      ),
    ],
    dos: const [
      'Focus on community & education.',
      'Set clear goals & KPIs.',
      'Show verifiable experience.',
      'Create value for new users.',
    ],
    donts: const [
      'Propose a heavily technical project.',
      'Submit vague goals or KPIs.',
      'Use vague team bios; link your work.',
      'Focus on giveaways/incentives.',
    ],
    submissionCloseDate: DateTimeExt.now(),
    imageUrl: '',
  ),
  //Midnight: Compact DApps
  CampaignCategory(
    id: f15ConstDocumentsRefs[3].category,
    campaignRef: Campaign.f15Ref,
    categoryName: 'Midnight:',
    categorySubname: 'Compact DApps',
    description:
        '''To accelerate developer adoption of Midnight by funding essential open-source reference DApps. This category is seeking reference DApps, and funding will be sponsored by the Midnight Foundation.''',
    shortDescription:
        'To accelerate developer adoption of Midnight by funding essential open-source reference DApps. This category is seeking reference DApps, and funding will be sponsored by the Midnight Foundation.',
    availableFunds: MultiCurrencyAmount.single(Currencies.usdm.amount(250000)),
    range: Range(
      min: Currencies.usdm.amount(2500),
      max: Currencies.usdm.amount(10000),
    ),
    currency: Currencies.usdm,
    descriptions: const [
      CategoryDescription(
        title: 'Overview',
        description: r'''
  Midnight Compact DApps is a strategic fund dedicated to building use cases and utility that will empower the future of privacy-enabled applications. This initiative leverages Catalyst's robust infrastructure and the wisdom of the Cardano community to help select the most promising projects that demonstrate the power of programmable privacy.

  ### Budget & Constraints

  - **Total Budget:** $USDM 250,000 
  - **Proposal Range:** From $USDM 2,500 to $USDM 10,000
  - Funding amounts are intended for small, focused prototypes, not full product builds.

  Sponsored by a $USDM 250,000 commitment from the Midnight Foundation, this initiative aims to build foundational “Reference DApps” for the new ecosystem. The Midnight Foundation is looking to fund high-impact, open-source projects that directly demonstrate high-value use cases for privacy-preserving applications, laying the critical groundwork of basic UI design and prototyping.

  ### Community Governance & Voting

  To celebrate the collaboration between the Midnight and Cardano ecosystems, project selection will be a two-stage process:

  1. **Community Recommendation:** Cardano's ADA holders will vote on proposals through Project Catalyst to create a shortlist of recommended projects.
  2. **Final Selection:** The Midnight Foundation will make the final funding decisions from the recommended list on behalf of the Midnight Foundation.

  ### Additional Notes

  - **Funding:** This funding is provided under executive sponsorship from the Midnight Foundation in [$USDM](https://moneta.global/). No funds from the Cardano Treasury will be used for this category.
  - **Infrastructure:** Project Catalyst will provide the voting platform on behalf of the Midnight Foundation. Catalyst voters will vote on the proposals submitted in this category, no different to other Catalyst funding categories, however the Midnight Foundation is solely responsible for funding decisions and disbursements.
  ''',
      ),
      CategoryDescription(
        title: 'Areas of Interest',
        description: '''
This category focuses on funding the creation of open-source Proof of Concept (PoC) decentralized applications (DApps) to demonstrate how Midnight technology works in practice. The primary goal is to build a library of functional examples that showcase what is possible on Midnight and serve as a learning resource for future developers in one of the following areas using Midnight:

- **Governance:** Build civic platforms that protect participants while still preserving fairness and auditability.
- **AI:** Midnight provides a foundation where AI can scale without sacrificing privacy, ensuring that data can be used responsibly, securely, and in ways that align with user consent
- **Health:** use Midnight to build patient-owned data systems, research networks, and telehealth tools that simply couldn't exist without privacy-preserving infrastructure.
- **Finance:** Midnight's programmable privacy means builders can create compliant financial products that aren't possible elsewhere like private credit markets, compliant DeFi rails, or new forms of digital banking.
- **Innovative & Novel Concepts:** Propose a creative concept that uniquely leverages Midnight's privacy features in another industry or real-world privacy enabled use case.

### What is a "Reference DApp"?

A Reference DApp is an open-source, Proof of Concept application built to demonstrate how to use Midnight's technology in practice. It is *not* meant to be a polished product or a company. Instead, its value lies in:

- **Clarity:** showing other developers how to implement a specific pattern (selective disclosure, privacy in finance, governance flows).
- **Reusability:** providing code that others can fork, remix, or extend.
- **Education:** acting as a practical example alongside documentation and tutorials.
- **Demonstration:** proving out Midnight's unique features with Compact contracts and a simple demo UI.

A good reference DApp should be small in scope but technically complete. Enough that another developer could run it locally, see it working, and adapt the code for their own project.
''',
      ),
      CategoryDescription(
        title: 'Core Eligibility: Who Can Apply?',
        description: '''
This category is for the builders. To be eligible, you and your project must meet the following criteria:

- **Technical Focus:** You must be proposing a functional software prototype with code as the primary outcome. Non-technical projects (marketing, content-only, community ops) are not eligible.
- **Verifiable Identity & Experience:** Anonymous or unverifiable teams are not eligible. The proposal must include verifiable identity and references (e.g., comprehensive LinkedIn profiles, GitHub profiles, project portfolios) that clearly demonstrate each key team member's specific experience and suitability for their role. Simply listing names/aliases is insufficient.
- **Direct Builders Only:** Proposals must be submitted by the builders who will perform the core work. Outsourcing the primary development to a third party agency is not permitted.
- **A 3-month timeline:** The project delivery timeline can be three months with three milestones each (one per month).
- **Open Source Commitment:** All code produced must be under a permissive open-source license (MIT or Apache-2.0) and source available from day one.
- **Maintain Good Standing with Catalyst:** The lead proposer and all named team members must be in full compliance with commitments for any previously funded Catalyst projects. Proposers can verify their compliance status by reviewing their reporting dashboard on the Project Catalyst platform. All milestone reports for previously funded projects must be submitted and approved on time prior to this fund's submission. [Learn more about it here.](https://forum.cardano.org/t/submitting-a-proposal-in-upcoming-fund15-read-this-first/149527)
''',
      ),
      CategoryDescription(
        title: 'Proposal Requirements',
        description: r'''
All proposals must provide the following information:

- **Demonstrate Novelty & Privacy Rationale:** Propose a unique, novel project (not a minor tweak of an existing Midnight reference dApp). If inspired by other ecosystems, clearly explain what's different and why it matters here. Explain why privacy improves this DApp; show you've thought through selective disclosure/programmable privacy. Don't treat Compact like TypeScript. They are distinct; proposals must use Compact for ZKPs.
- **Define Target Audience:** Clearly describe both the target end-user of the DApp and the developer personas who will learn from your code repository.
- **Provide Verifiable Team Credentials:** Link to GitHub profiles, past projects, or code samples that prove your team has the technical ability to deliver the project.
- **Detailed Project Deliverables:** All final projects must include the following technical baseline:
   - **Compact contract:** At least one **\*.compact** smart contract demonstrating programmable privacy/selective disclosure.
   - **Demo UI:** A simple UI in the repo that calls your Compact contract and shows a demo flow.
   - **Wallet integration:** Integrate with the Lace (Midnight) wallet.
   - **Open-source repo:** Public code with a permissive OSI license (MIT or Apache-2.0).
   - **Robust README.md:** What it does, why privacy matters, how to run locally, key files, and suggested next steps/extensions.
   - **Test Suite:** Tests for the contract (sample inputs/outputs for privacy features) with clear instructions to run tests.
''',
      ),
      CategoryDescription(
        title: 'Self-Assessment Checklist',
        description: '''
Use this checklist to ensure your proposal meets all foundational and content requirements before submission.

| **Rule & Check** | **Description** |
|:----------|:----------|
| **Strategic Fit** | The proposal clearly provides a basic prototype reference application for one of the areas of interest. |
| **Developer Experience Focus** | The proposal clearly defines which part of the developer journey it improves and how it makes building on Midnight easier and more productive. |
| **Open Source Commitment** | The proposal explicitly states the chosen permissive open-source license (e.g., MIT, Apache 2.0) and commits to a public code repository. |
| **Verifiable Builder Credentials** | The team provides evidence of their technical ability and experience in creating developer tools or high-quality technical content (e.g., GitHub, portfolio). |
| **High-Quality Documentation** | A plan for creating and maintaining clear, comprehensive documentation is a core part of the proposal's scope. |
| **Realistic Scope** | The budget and timeline (3 months) are realistic for delivering the proposed tool or resource. |
''',
      ),
    ],
    dos: const [
      'Propose a novel project.',
      'Explain the privacy benefit.',
      'Use a permissive open-source license.',
      'Focus on functional code.',
      'Link to your GitHub & past work.',
    ],
    donts: const [
      'Propose non-technical work.',
      'Submit "idea-only" proposals.',
      'Treat Compact like TypeScript.',
      'Outsource the core development.',
    ],
    submissionCloseDate: DateTimeExt.now(),
    imageUrl: '',
  ),
];
