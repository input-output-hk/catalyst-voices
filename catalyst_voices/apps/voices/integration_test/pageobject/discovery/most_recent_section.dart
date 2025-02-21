import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import '../../utils/translations_utils.dart';

class MostRecentSection {
  MostRecentSection(this.$);

  late PatrolTester $;
  final mostRecentProposals = const Key('MostRecentProposals');
  final mostRecentProposalsTitle = const Key('MostRecentProposalsTitle');
  final pendingProposalCard = const Key('PendingProposalCard');
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
        .$(pendingProposalCard)
        .at(0)
        .$(commentsCount)
        .scrollTo(step: 90);

    // TODO(oldgreg): there are only 3 cards indexed(rendered) always,need to
    // find a way to check cards past 3rd after horizontal scroll
    for (var i = 0; i < 3; i++) {
      await $(mostRecentProposals)
          .$(pendingProposalCard)
          .at(i)
          .$(favoriteButton)
          .scrollTo(scrollDirection: AxisDirection.right);
      expect(
        $(mostRecentProposals).$(pendingProposalCard).at(i).$(category).text,
        isNotEmpty,
      );
      expect(
        $(mostRecentProposals).$(pendingProposalCard).at(i).$(title).first.text,
        isNotEmpty,
      );
      expect(
        $(mostRecentProposals).$(pendingProposalCard).at(i).$(shareButton),
        findsOneWidget,
      );
      expect(
        $(mostRecentProposals).$(pendingProposalCard).at(i).$(favoriteButton),
        findsOneWidget,
      );
      expect(
        $(mostRecentProposals)
            .$(pendingProposalCard)
            .at(i)
            .$(authorAvatar)
            .$(Text)
            .text,
        isNotEmpty,
      );
      expect(
        $(mostRecentProposals).$(pendingProposalCard).at(i).$(author).text,
        isNotEmpty,
      );
      expect(
        $(mostRecentProposals)
            .$(pendingProposalCard)
            .at(i)
            .$(fundsRequested)
            .$(title)
            .text,
        T.get('Funds requested'),
      );
      expect(
        $(mostRecentProposals)
            .$(pendingProposalCard)
            .at(i)
            .$(fundsRequested)
            .$(value)
            .text,
        isNotEmpty,
      );
      expect(
        $(mostRecentProposals)
            .$(pendingProposalCard)
            .at(i)
            .$(duration)
            .$(title)
            .text,
        T.get('Duration'),
      );
      expect(
        $(mostRecentProposals)
            .$(pendingProposalCard)
            .at(i)
            .$(duration)
            .$(value)
            .text,
        isNotEmpty,
      );
      expect(
        $(mostRecentProposals).$(pendingProposalCard).at(i).$(description).text,
        isNotEmpty,
      );
      expect(
        $(mostRecentProposals)
            .$(pendingProposalCard)
            .at(i)
            .$(proposalStage)
            .text,
        isNotEmpty,
      );
      expect(
        $(mostRecentProposals).$(pendingProposalCard).at(i).$(version).text,
        isNotEmpty,
      );
      expect(
        $(mostRecentProposals)
            .$(pendingProposalCard)
            .at(i)
            .$(timezoneDateTimeText)
            .text,
        isNotEmpty,
      );
      expect(
        $(mostRecentProposals)
            .$(pendingProposalCard)
            .at(i)
            .$(commentsCount)
            .text,
        isNotEmpty,
      );
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

  Future<bool> loadingErrorIsVisible() async {
    try {
      return $(mostRecentLoadingError).$(#ErrorRetryBtn).visible;
    } catch (e) {
      return false;
    }
  }

  Future<void> loadingErrorClick() async {
    await $(mostRecentLoadingError).$(#ErrorRetryBtn).tap();
  }

  Future<void> loadRetryOnError() async {
    try {
      await $(mostRecentLoadingError)
          .$(#ErrorRetryBtn)
          .scrollTo(step: 300, maxScrolls: 5);
    } finally {}
    if (await loadingErrorIsVisible()) {
      var i = 0;
      for (i = 0; i < 9; i++) {
        await loadingErrorClick();
        await Future<void>.delayed(const Duration(seconds: 5));
        if (!(await loadingErrorIsVisible())) {
          break;
        }
      }
      expect(
        await loadingErrorIsVisible(),
        false,
        reason: 'Max ${i - 1} retries exceeded',
      );
    }
  }

  Future<void> looksAsExpectedForVisitor() async {
    await loadRetryOnError();
    await titleIsRenderedCorrectly();
    await recentProposalsAreRenderedCorrectly();
  }
}
