import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

/// List of static [CampaignCategory] definitions.
///
/// Categories will come from documents later.
///
/// See [CampaignCategory].
final f14StaticCampaignCategories = [
  CampaignCategory(
    selfRef: f14ConstDocumentsRefs[0].category,
    campaignRef: Campaign.f14Ref,
    categoryName: 'Cardano Use Case:',
    categorySubname: 'Partners & Products',
    description:
        '''Cardano Use Cases: Partners & Products empowers exceptional applications and enterprise collaborations to enhance products and services with capabilities that drive high-volume transactions and accelerates mainstream adoption.''',
    shortDescription:
        'For Tier-1 collaborations and real-world pilots that scale Cardano adoption through high-impact use cases.',
    proposalsCount: 0,
    availableFunds: MultiCurrencyAmount.single(Currencies.ada.amount(8500000)),
    imageUrl: '',
    totalAsk: MultiCurrencyAmount.single(Currencies.ada.amount(0)),
    range: Range(
      min: Currencies.ada.amount(250000),
      max: Currencies.ada.amount(1000000),
    ),
    currency: Currencies.ada,
    descriptions: const [
      CategoryDescription(
        title: 'Overview',
        description: '''
Cardano Partners & Products accelerates Cardano’s mainstream adoption by supporting mature, mainnet-deployed products and strategic enterprise collaborations that deliver real-world utility and high-value transactions.\n\nUnlike Cardano Use Cases: Concepts, which funds novel, early-stage ideas like prototypes or MVPs, this funding category is for established teams or enterprises with proven products or collaborations driving measurable adoption.''',
      ),
      CategoryDescription(
        title: 'Who should apply',
        description: '''
Cardano Partners & Products funds enterprise R&D collaborations between Cardano-based businesses and teams with Tier-1 industry leaders to integrate Cardano solutions into real world use cases.\n\nThis category is for established enterprises or startups with mainnet-deployed Cardano-based products or industry leading collaborations.\n\nIf your project is an early-stage concept, prototype, or lacks mainnet deployment, apply to _Cardano Use Cases: Concepts_ instead.
''',
      ),
      CategoryDescription(
        title: 'Areas of Interest',
        description: '''
Proposals should focus on mature R&D for products with Tier-1 collaborations, such as:

- Enterprise integrations and demonstrator pilots with Tier-1 industry leaders _e.g. embedding Cardano wallets in automotive systems._
- Stablecoin use-cases: Partner-led pilots that show Cardano stablecoins in action supporting real transactions, liquidity, utility, or payments on Cardano.
- Maturing use cases using Cardano scaling solutions like Hydra _e.g. a high-throughput payment system into household-name ecommerce marketplace providers_
- Applications leveraging exponential technologies like AI _e.g. an AI-enhanced supply chain solution with a large manufacturer_
- All projects should have measurable adoption outcomes _e.g. a tokenized asset platform with validated transaction growth._
''',
      ),
      CategoryDescription(
        title: 'Proposal Guidance',
        description: '''
- Proposals must demonstrate measurable adoption outcomes and a clear link to Cardano’s blockchain _e.g. transaction volume, user growth, liquidity metrics_
- Projects must be led by or partnered with industry leading businesses that have 2+ years business track record
- Projects must provide evidence of a working product
- Projects should be prepared to demonstrate an established business collaboration as well as relevant experience in the area to at least the Catalyst Team as the Fund Operator, if commercial details cannot be made public
- Clearly state funding commitments to show their commitment to the project
- Projects may be proprietary or open source but must drive high-volume/value transactions and co-marketing opportunities.
- Co-marketing plans and community engagement to amplify Cardano’s partnership visibility.
- Early-stage concepts or prototypes should apply to _Cardano Use Cases: Concepts._
- Projects that aren’t primarily focused on R&D and demonstrating the utility of enabling applications
''',
      ),
      CategoryDescription(
        title: 'Eligibility Criteria',
        description: '''
The following will **not** be funded:

- Early-stage concepts or prototypes _e.g. a new DeFi protocol MVP proposal belongs in Cardano Use Cases: Concepts._
- Foundational R&D or maintenance for critical infrastructure. These belong to other Cardano funding streams such as via a members organization or direct governance action for treasury withdrawal and administrations _e.g. Cardano protocol, Layer 2 solutions_
- Proposals lacking evidence of a mainnet-deployed product or collaboration with a Tier-1 industry leader.
- Developer tools, middleware, APIs, or integrated development environments belong in Cardano Open: Developers.
- Projects lacking measurable adoption outcomes or Cardano relevance.
- Proposals to use funds primarily for liquidity, loans, NFTs, or buying token-based products without technical integration.
- Informational content, websites, or blogs _e.g. a Cardano education site_.
''',
      ),
    ],
    dos: const [
      '**Provide proof** of established collaborations',
      '**Provide proof** of key performance metrics',
      '**Clarify** funding commitments',
    ],
    donts: const [
      '**No** prototype R&D',
      '**No** Cardano infrastructure',
      '**No** way to prove your impact',
    ],
    submissionCloseDate: DateTimeExt.now(),
  ),
  CampaignCategory(
    selfRef: f14ConstDocumentsRefs[1].category,
    campaignRef: Campaign.f14Ref,
    categoryName: 'Cardano Use Case:',
    categorySubname: 'Concept',
    description:
        '''Cardano Use Cases: Concepts funds novel, early-stage Cardano-based concepts developing proof of concept prototypes through deploying minimum viable products (MVP) to validate innovative products, services, or business models driving Cardano adoption.''',
    shortDescription:
        'For early-stage ideas to create, test, and validate Cardano-based prototypes to MVP innovations.',
    proposalsCount: 0,
    availableFunds: MultiCurrencyAmount.single(Currencies.ada.amount(4000000)),
    imageUrl: '',
    totalAsk: MultiCurrencyAmount.single(Currencies.ada.amount(0)),
    range: Range(
      min: Currencies.ada.amount(15000),
      max: Currencies.ada.amount(100000),
    ),
    currency: Currencies.ada,
    descriptions: const [
      CategoryDescription(
        title: 'Overview',
        description: '''
Cardano Use Cases: Concepts category fuels disruptive, untested Cardano-based use cases to experiment with novel utility and on-chain transactions.

The funding category supports early-stage ideas - spanning proof of concept, design research, basic prototyping, and minimum viable products (MVPs) - to lay the foundation for innovative products, services, or business models.

Unlike _Cardano Use Cases: Partners & Products_, which funds mature, deployed products or enterprise collaborations with proven adoption, this category is for newer Catalyst entrants or innovators validating novel concepts and product market fit with no prior development or funding.
''',
      ),
      CategoryDescription(
        title: 'Who should apply?',
        description: '''
This category is for entrepreneurs, designers, and innovators with original, untested Cardano-based concepts, such as a DeFi startup researching a novel lending protocol, a Web3 developer prototyping a zero-knowledge identity solution, or a researcher exploring AI-blockchain integration. If your project involves a mature product, enterprise collaboration, or incremental feature enhancements, apply to _Cardano Use Cases: Partners & Products_ instead.
''',
      ),
      CategoryDescription(
        title: 'Areas of Interest',
        description: '''
- Disruptive industrial innovations using Cardano’s blockchain and smart contracts
- DeFi solutions with unique approaches _e.g. a peer-to-peer yield and novel bond curve protocol MVP._
- Privacy, oracles, or zero-knowledge proof applications.
- Projects porting or bridging from other ecosystems _e.g. a wallet prototyping Cardano Native Token support_.
- Prototyping on Cardano scaling solutions like Hydra _e.g. a high-throughput payment prototype_.
- Technical blockchain research with exponential technologies _e.g. a feasibility study for AI-driven oracles_.
''',
      ),
      CategoryDescription(
        title: 'Proposal Guidance',
        description: '''
- Proposals adding features to existing early-stage prototypes must provide evidence of the prototype’s novelty and early status _e.g. URL, demo, developer repository_
- Proposals must describe the concept’s novelty, explaining how it differs from existing solutions and confirming no prior Catalyst funding or development.
- Demonstrate how the project could drive Cardano adoption through increased on-chain transactions and you intend to validate potential.
- Projects may be proprietary or open source but must clearly benefit the Cardano ecosystem.
- New concepts must be original and not previously developed.
- Mature products with enterprise partnerships, and enhancements for deployed solutions should apply to _Cardano Use Cases: Partners & Products._
- Proposals must have a delivery timeline of no more than 12 months.
''',
      ),
      CategoryDescription(
        title: 'Eligibility Criteria',
        description: '''
The following will **not** be funded:

- Proposals for mature products, incremental improvements, or enterprise partnerships _e.g. scaling an existing DeFi app or adding features to a deployed wallet belong in Cardano Use Cases: Partners & Products_.
- Proposals focused on informational content only, websites, or blogs _e.g. a Cardano education site belong instead in Cardano Open: Ecosystem._
- Infrastructure or tooling projects not tied to specific Cardano use cases belong in either Cardano Open: Developers or requesting funds from another Cardano funding stream _e.g. members organization or DAO_.
- Proposals lacking a clear link to Cardano or potential to generate transactions on chain.
''',
      ),
    ],
    dos: const [
      '**Propose** fresh ideas that haven’t been funded before',
      '**Produce** a working on-chain prototype or MVP',
      '**Provide** realistic blockchain usage projections',
    ],
    donts: const [
      '**No** existing Cardano products',
      '**No** info-only websites and content',
      '**No** moon metrics!',
    ],
    submissionCloseDate: DateTimeExt.now(),
  ),
  CampaignCategory(
    selfRef: f14ConstDocumentsRefs[2].category,
    campaignRef: Campaign.f14Ref,
    categoryName: 'Cardano Open:',
    categorySubname: 'Developers',
    description: '''
Funds open source tools and environments to enhance the Cardano developer experience. Apply to create impactful, community-driven open source solutions!
''',
    shortDescription:
        'For developers to build open-source tools that enhance the Cardano developer experience.',
    proposalsCount: 0,
    availableFunds: MultiCurrencyAmount.single(Currencies.ada.amount(3100000)),
    imageUrl: '',
    totalAsk: MultiCurrencyAmount.single(Currencies.ada.amount(0)),
    range: Range(
      min: Currencies.ada.amount(15000),
      max: Currencies.ada.amount(100000),
    ),
    currency: Currencies.ada,
    descriptions: const [
      CategoryDescription(
        title: 'Overview',
        description: '''
Cardano Open: Developers will fund devs, programmers, and engineers creating or contributing to open source technologies that strengthen the Cardano developer ecosystem. We believe in open source software, hardware, and data solutions driving transparency, security, and collaboration for the good of the network.

The goal is to streamline integrated development environments, boost coding efficiency, and simplify the developer experience on Cardano.

Learn more about open source at [opensource.org](https://opensource.org/).
''',
      ),
      CategoryDescription(
        title: 'Who should apply?',
        description: '''
This category is for software developers, blockchain engineers, data architects, and open source contributors eager to build O/S tools, libraries, or environments that improve the Cardano developer ecosystem.

The scope is wide open for creating smart contract debugging tools, crafting SDKs support new languages, or DevOps specialists designing interoperability CLIs. If your proposal focuses on non-technical initiatives like education or marketing, apply to _Cardano Open: Ecosystem_ instead.
''',
      ),
      CategoryDescription(
        title: 'Areas of interest',
        description: '''
Proposals may focus on open source technical solutions, for example:

- Standardizing, developing, or supporting full-stack solutions and integrated development environments _e.g. new language and code extension support for Plutus debugging_.
- Creating libraries, SDKs, APIs, toolchains, or frameworks _e.g., new SDKs for Cardano privacy preserving smart contracts_.
- Developing governance and blockchain interoperability tooling _e.g. a CLI tool for cross-chain transaction validation_
''',
      ),
      CategoryDescription(
        title: 'Proposal Guidance',
        description: '''
- Proposals must be source-available from day one with a declared open source repository e.g. GitHub, GitLab.
- Select an OSI-approved open source license e.g. MIT, Apache 2.0, GPLv3) that permits the community to freely copy, inspect, and modify the project’s output. Visit [choosealicense.com](https://choosealicense.com/) for guidance.
- Ensure thorough documentation is available from day one and updated regularly.
- Describe how the project will benefit the Cardano developer community and foster collaboration e.g. through tutorials, webinars, or forum posts.
- Proposals must have a delivery timeline of no more than 12 months.
''',
      ),
      CategoryDescription(
        title: 'Eligibility Criteria',
        description: '''
The following will **not** be funded:

- Proposals not primarily developing new technology or contributing to existing open source technology _e.g. learning guides for Plutus or Aiken, these would belong in the Cardano Open: Ecosystem category_.
- Proposals producing proprietary software/hardware or open sourcing only a portion of the codebase.
- Proposals lacking an OSI-approved open source license, public repository, or high-quality documentation from day one.
- Proposals not directly enhancing the Cardano developer experience _e.g. general blockchain tools without Cardano-specific integration._
''',
      ),
    ],
    dos: const [
      '**Open source** licensing of project outputs is required',
      '**Clear statement** of your open source license',
      '**Open source outputs** from project start',
      '**Provide** high quality documentation',
    ],
    donts: const [
      '**No** proprietary materials (including software or hardware)',
      '**No** projects that are non-technical',
      '**No** info-only websites and content',
      '**Forget to be open**, public, and available on Day 1',
    ],
    submissionCloseDate: DateTimeExt.now(),
  ),
  CampaignCategory(
    selfRef: f14ConstDocumentsRefs[3].category,
    campaignRef: Campaign.f14Ref,
    categoryName: 'Cardano Open:',
    categorySubname: 'Ecosystem',
    description: '''
Funds non-technical initiatives like marketing, education, and community building to grow Cardano’s ecosystem and onboard new users globally.
''',
    shortDescription:
        'For non-tech projects like marketing, education, or community growth to expand Cardano’s reach.',
    proposalsCount: 0,
    availableFunds: MultiCurrencyAmount.single(Currencies.ada.amount(3000000)),
    imageUrl: '',
    totalAsk: MultiCurrencyAmount.single(Currencies.ada.amount(0)),
    range: Range(
      min: Currencies.ada.amount(15000),
      max: Currencies.ada.amount(60000),
    ),
    currency: Currencies.ada,
    descriptions: const [
      CategoryDescription(
        title: 'Overview',
        description: '''
Cardano Open: Ecosystem will fund non-technical initiatives that drive grassroots ecosystem growth, education, and community engagement to broaden Cardano’s reach and onboard new users.

Cardano’s passionate global community is a foundation for growth, yet more can be done to expand adoption. This category focuses on building the creative capacity to deliver local campaigns and beyond that bring awareness and attention to Cardano from the hearts and minds of the grassroots community collective.  

Learn more at [](https://cardano.org/)[cardano.org](http://cardano.org).
''',
      ),
      CategoryDescription(
        title: 'Who should apply?',
        description: '''
This category is for educators, marketers, content creators, and community leaders passionate about expanding Cardano’s global reach through non-technical initiatives, such as marketing experts launching social media campaigns, educators developing blockchain courses, or community organizers hosting hackathons. If your proposal focuses on software or hardware development, apply to Cardano Use Cases or Cardano Open: Developers instead.
''',
      ),
      CategoryDescription(
        title: 'Areas of interest',
        description: '''
Proposals may focus on non-technical initiatives, such as:  

- Cardano Community Hubs that create or maintain a local Cardano presence in cities or regions worldwide
- Growth-focused marketing campaigns and public outreach _e.g. a social media campaign to promote Cardano adoption._
- Community hackathons or builder outreach events _e.g. a virtual workshop for new developers._
- Content creation or curation _e.g. educational videos on Cardano’s features_.
- Mentorship, incubation, or collaboration programs _e.g. a startup accelerator for Cardano-based projects._
- Educational advancements _e.g. a university course on blockchain with Cardano case studies._
- Local policy, standards, or regulation advocacy _e.g. a policy paper on Cardano’s role in regional finance and pathways to present to local authorities_
''',
      ),
      CategoryDescription(
        title: 'Proposal Guidance',
        description: '''
- Proposals must focus on non-technical initiatives like marketing, education, or community building, not software/hardware development.
- Clearly articulate how the initiative will expand Cardano’s global footprint or onboard new users, using measurable Key Performance Indicators (KPIs) and relevant metrics _e.g. event attendance, content reach, new user registrations_.
- Ensure activities are inclusive and accessible to both existing and new Cardano communities.
- Proposals must have a delivery timeline of no more than 12 months.
- Publicly accessible outputs where applicable _e.g. educational content, event reports, or marketing materials._
- A timeline with clear milestones _e.g. campaign launch, event dates, content release._
- _Optional_: Plans for sustained community engagement, such as follow-up events, social media campaigns, or mentorship programs.
''',
      ),
      CategoryDescription(
        title: 'Eligibility Criteria',
        description: '''
The following will **not** be funded:

- Proposals not primarily focused on grassroots ecosystem growth through marketing, education, or community building.
- Proposals centered on software or hardware development _e.g. a fan loyalty platform or marketing automation tool belong in Cardano Use Cases category_.
- Proposals lacking clear goals, measurable outcomes, KPIs, or relevance to Cardano’s ecosystem.
''',
      ),
    ],
    dos: const [
      '**Deliver** Community engagement projects',
      '**Deliver** grassroots growth, education projects',
      '**Clearly outline** goals, activities, and measurable outcomes',
      '**Design** for new Cardano communities',
    ],
    donts: const [
      '**No** software or hardware development',
      '**No** vague or irrelevant value to Cardano',
      '**No** clear targets or KPIs',
    ],
    submissionCloseDate: DateTimeExt.now(),
  ),
];
