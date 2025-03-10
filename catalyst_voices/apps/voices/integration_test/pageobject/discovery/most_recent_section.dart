import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/translations_utils.dart';
import '../discovery_page.dart';

class MostRecentSection {
  MostRecentSection(this.$);

  late PatrolTester $;
  final mostRecentProposals = const Key('MostRecentProposals');
  final mostRecentProposalsTitle = const Key('MostRecentProposalsTitle');
  final proposalCard = const Key('ProposalCard');
  final mostRecentOffstage = const Key('MostRecentOffstage');
  final shareButton = const Key('ShareBtn');
  final favoriteButton = const Key('FavoriteBtn');
  final category = const Key('Category');
  final title = const Key('Title');
  final value = const Key('Value');
  final authorAvatar = const Key('AuthorAvatar');
  final author = const Key('Author');
  final fundsRequested = const Key('FundsRequested');
  final duration = const Key('Duration');
  final description = const Key('Description');
  final proposalStage = const Key('ProposalStage');
  final version = const Key('Version');
  final timezoneDateTimeText = const Key('TimezoneDateTimeText');
  final viewAllProposalsButton = const Key('ViewAllProposalsBtn');
  final mostRecentProposalsSlider = const Key('MostRecentProposalsSlider');
  final commentsCount = const Key('CommentsCount');
  final mostRecentLoadingError = const Key('MostRecentError');

  Future<void> titleIsRenderedCorrectly() async {
    await $(mostRecentProposalsTitle).scrollTo();
    expect($(mostRecentProposalsTitle).text, T.get('Most Recent'));
  }

  Future<void> recentProposalsAreRenderedCorrectly() async {
    await $(mostRecentProposals)
        .$(proposalCard)
        .at(0)
        .$(commentsCount)
        .scrollTo(step: 90);

    // TODO(oldgreg): there are only 3 cards indexed(rendered) always,need to
    // find a way to check cards past 3rd after horizontal scroll
    for (var cardIndex = 0; cardIndex < 3; cardIndex++) {
      await $(mostRecentProposals)
          .$(proposalCard)
          .at(cardIndex)
          .$(favoriteButton)
          .scrollTo(scrollDirection: AxisDirection.right);
      await proposalCardLooksAsExpected(mostRecentProposals, cardIndex);
    }
    expect(
      $(mostRecentProposals).$(mostRecentProposalsSlider).visible,
      true,
    );
    expect(
      $(mostRecentProposals).$(viewAllProposalsButton).text,
      T.get('View All Proposals'),
    );
  }

  Future<void> proposalCardLooksAsExpected(
    Key parentContainer,
    int cardIndex,
  ) async {
    expect(
      $(parentContainer).$(proposalCard).at(cardIndex).$(category).text,
      isNotEmpty,
    );
    expect(
      $(parentContainer).$(proposalCard).at(cardIndex).$(title).first.text,
      isNotEmpty,
    );
    expect(
      $(parentContainer).$(proposalCard).at(cardIndex).$(shareButton),
      findsOneWidget,
    );
    expect(
      $(parentContainer).$(proposalCard).at(cardIndex).$(favoriteButton),
      findsOneWidget,
    );
    expect(
      $(parentContainer)
          .$(proposalCard)
          .at(cardIndex)
          .$(authorAvatar)
          .$(Text)
          .text,
      isNotEmpty,
    );
    expect(
      $(parentContainer).$(proposalCard).at(cardIndex).$(author).text,
      isNotEmpty,
    );
    expect(
      $(parentContainer)
          .$(proposalCard)
          .at(cardIndex)
          .$(fundsRequested)
          .$(title)
          .text,
      T.get('Funds requested'),
    );
    expect(
      $(parentContainer)
          .$(proposalCard)
          .at(cardIndex)
          .$(fundsRequested)
          .$(value)
          .text,
      isNotEmpty,
    );
    expect(
      $(parentContainer)
          .$(proposalCard)
          .at(cardIndex)
          .$(duration)
          .$(title)
          .text,
      T.get('Duration'),
    );
    expect(
      $(parentContainer)
          .$(proposalCard)
          .at(cardIndex)
          .$(duration)
          .$(value)
          .text,
      isNotEmpty,
    );
    expect(
      $(parentContainer).$(proposalCard).at(cardIndex).$(description).text,
      isNotEmpty,
    );
    expect(
      $(parentContainer).$(proposalCard).at(cardIndex).$(proposalStage).text,
      isNotEmpty,
    );
    expect(
      $(parentContainer).$(proposalCard).at(cardIndex).$(version).text,
      isNotEmpty,
    );
    expect(
      $(parentContainer)
          .$(proposalCard)
          .at(cardIndex)
          .$(timezoneDateTimeText)
          .text,
      isNotEmpty,
    );
    expect(
      $(parentContainer).$(proposalCard).at(cardIndex).$(commentsCount).text,
      isNotEmpty,
    );
  }

  Future<void> tryToScrollToRetryError() async {
    try {
      await $(mostRecentLoadingError)
          .$(#ErrorRetryBtn)
          .scrollTo(step: 300, maxScrolls: 5);
    } catch (e) {
      return;
    }
  }

  Future<void> looksAsExpectedForVisitor() async {
    await tryToScrollToRetryError();
    await DiscoveryPage($).loadRetryOnError(mostRecentLoadingError);
    await titleIsRenderedCorrectly();
    await recentProposalsAreRenderedCorrectly();
  }
}
