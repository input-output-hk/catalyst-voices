import 'package:catalyst_voices/widgets/cards/proposal/proposal_card_widgets.dart'
    show DraftProposalChip, FinalProposalChip, PrivateProposalChip;
import 'package:catalyst_voices/widgets/cards/proposal/small_proposal_card.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart'
    show ProposalVersionViewModel, UsersProposalOverview;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid_plus/uuid_plus.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SmallProposalCard', () {
    late UsersProposalOverview mockProposal;
    late String proposalId;
    late String latestVersion;
    late String localVersion;
    late String draftVersion;

    setUpAll(() async {
      // TODO(LynxLynxx): When we create dev test package use DocumentFactoryRef here
      // Extracting DocumentFactoryRef to Shared not possible due to need of importing classes from
      // repository package
      proposalId = const Uuid().v7();
      draftVersion = const Uuid().v7();
      await Future.delayed(const Duration(milliseconds: 10), () {});
      latestVersion = const Uuid().v7();
      await Future.delayed(const Duration(milliseconds: 10), () {});
      localVersion = const Uuid().v7();
      mockProposal = UsersProposalOverview(
        selfRef: SignedDocumentRef(id: proposalId, version: latestVersion),
        parameters: DocumentParameters({SignedDocumentRef.generateFirstRef()}),
        title: 'Test Proposal',
        updateDate: DateTime.now(),
        fundsRequested: Money.zero(currency: Currencies.ada),
        publish: ProposalPublish.publishedDraft,
        versions: [
          ProposalVersionViewModel(
            publish: ProposalPublish.localDraft,
            selfRef: DraftRef(id: proposalId, version: localVersion),
            title: 'Title ver 1',
            createdAt: DateTime.now(),
            isLatest: true,
            isLatestLocal: true,
            versionNumber: 3,
          ),
          ProposalVersionViewModel(
            publish: ProposalPublish.publishedDraft,
            selfRef: SignedDocumentRef(id: proposalId, version: latestVersion),
            title: 'Test Proposal',
            createdAt: DateTime.now(),
            isLatest: false,
            isLatestLocal: false,
            versionNumber: 2,
          ),
          ProposalVersionViewModel(
            publish: ProposalPublish.publishedDraft,
            selfRef: SignedDocumentRef(id: proposalId, version: draftVersion),
            title: 'Title ver 2',
            createdAt: DateTime.now(),
            isLatest: false,
            isLatestLocal: false,
            versionNumber: 1,
          ),
        ],
        fundNumber: 14,
        commentsCount: 0,
        category: 'Cardano Use Cases: Concept',
        fromActiveCampaign: true,
      );
    });

    Future<void> pumpCard(
      WidgetTester tester, {
      bool showLatestLocal = false,
    }) async {
      await tester.pumpApp(
        SizedBox(
          width: 1000,
          height: 1000,
          child: SmallProposalCard(
            proposal: mockProposal,
            showLatestLocal: showLatestLocal,
          ),
        ),
      );
    }

    testWidgets('renders basic proposal information', (tester) async {
      await pumpCard(tester);
      await tester.pumpAndSettle();

      expect(find.byType(SmallProposalCard), findsOneWidget);
      expect(find.text('Test Proposal'), findsOneWidget);
      expect(find.text('Cardano Use Cases: Concept'), findsOneWidget);
    });

    testWidgets('shows version number', (tester) async {
      await pumpCard(tester);
      await tester.pumpAndSettle();

      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('shows new iteration details when showLatestLocal '
        'is true and has latest local draft', (tester) async {
      await pumpCard(tester, showLatestLocal: true);
      await tester.pumpAndSettle();

      expect(
        find.text('Consider publishing this newer iteration!'),
        findsOneWidget,
      );
    });

    testWidgets('hides new iteration details when showLatestLocal is false', (tester) async {
      await pumpCard(tester);
      await tester.pumpAndSettle();

      expect(
        find.text('Consider publishing this newer iteration!'),
        findsNothing,
      );
    });

    testWidgets('shows correct chip based on proposal publish status', (tester) async {
      // Test for published draft
      mockProposal = mockProposal.copyWith(publish: ProposalPublish.publishedDraft);
      await pumpCard(tester);
      await tester.pumpAndSettle();
      expect(find.byType(DraftProposalChip), findsOneWidget);

      // Test for submitted proposal
      mockProposal = mockProposal.copyWith(publish: ProposalPublish.submittedProposal);
      await pumpCard(tester);
      await tester.pumpAndSettle();
      expect(find.byType(FinalProposalChip), findsOneWidget);

      // Test for local draft
      mockProposal = mockProposal.copyWith(publish: ProposalPublish.localDraft);
      await pumpCard(tester);
      await tester.pumpAndSettle();
      expect(find.byType(PrivateProposalChip), findsOneWidget);
    });
  });
}
