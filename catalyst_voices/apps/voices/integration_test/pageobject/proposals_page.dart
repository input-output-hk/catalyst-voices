import 'package:catalyst_voices/widgets/search/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../utils/translations_utils.dart';
import 'app_bar_page.dart';
import 'common_page.dart';
import 'discovery/most_recent_section.dart';

class ProposalsPage {
  ProposalsPage(this.$);

  late PatrolTester $;
  final currentCampaignTitle = const Key('CurrentCampaignTitle');
  final currentCampaignDescription = const Key('CurrentCampaignDescription');
  final campaignDetailsButton = const Key('CampaignDetailsButton');
  final allProposalsTab = const Key('AllProposalsTab');
  final draftProposalsTab = const Key('DraftProposalsTab');
  final finalProposalsTab = const Key('FinalProposalsTab');
  final favoriteProposalsTab = const Key('FavoriteProposalsTab');
  final myProposalsTab = const Key('MyProposalsTab');
  final categorySelector = const Key('ChangeCategoryBtnSelector');
  final categorySelectorLabel = const Key('CategorySelectorLabel');
  final categorySelectorValue = const Key('CategorySelectorValue');
  final searchProposalsField = const Key('SearchProposalsField');
  final proposalsContainer = const Key('ProposalsTabBarStackView');

  Future<void> looksAsExpectedForVisitor() async {
    await AppBarPage($).looksAsExpectedForVisitor();
    await navigationBackButtonIsVisible();
    await currentCampaignDetailsLooksAsExpected();
    await proposalsTabsLookAsExpected();
    await changeCategoriesBtnLooksAsExpected();
    await searchFieldLooksAsExpected();
    await proposalCardsLookAsExpected();
    await paginationInfoLooksAsExpected();
  }

  Future<void> navigationBackButtonIsVisible() async {
    expect($(CommonPage($).navigationBackBtn).$(Text).text, T.get('Back'));
  }

  Future<void> currentCampaignDetailsLooksAsExpected() async {
    expect(
      $(currentCampaignTitle).text?.startsWith(T.get('Catalyst Fund ')),
      true,
    );
    expect($(currentCampaignDescription).text, isNotEmpty);
    expect($(campaignDetailsButton).$(Text).text, T.get('Campaign Details'));
  }

  Future<void> proposalsTabsLookAsExpected() async {
    expect(
      $(allProposalsTab).$(Text).text?.startsWith(T.get('All (')),
      true,
    );
    expect(
      $(draftProposalsTab).$(Text).text?.startsWith(T.get('Draft proposals (')),
      true,
    );
    expect(
      $(finalProposalsTab).$(Text).text?.startsWith(T.get('Final proposals (')),
      true,
    );
    expect(
      $(favoriteProposalsTab).$(Text).text?.startsWith(T.get('Favorites (')),
      true,
    );
    expect(
      $(myProposalsTab).$(Text).text?.startsWith(T.get('My proposals (')),
      true,
    );
  }

  Future<void> changeCategoriesBtnLooksAsExpected() async {
    expect($(categorySelectorLabel).text, T.get('Category'));
    expect($(categorySelectorValue).text, T.get('Show All'));
  }

  Future<void> searchFieldLooksAsExpected() async {
    final searchHintText =
        $.tester.widget<SearchTextField>($(searchProposalsField)).hintText;
    expect(searchHintText, T.get('Search Proposals'));
  }

  Future<void> proposalCardsLookAsExpected() async {
    final proposalsCount = $.tester
        .widgetList<Material>(
            $(proposalsContainer).$(MostRecentSection($).proposalCard))
        .length;
    for (var cardIndex = 0; cardIndex < proposalsCount; cardIndex++) {
      await $(proposalsContainer)
          .$(MostRecentSection($).proposalCard)
          .at(cardIndex)
          .scrollTo();
      await MostRecentSection($)
          .proposalCardLooksAsExpected(proposalsContainer, cardIndex);
    }
  }

  Future<void> paginationInfoLooksAsExpected() async {
    await $(CommonPage($).paginationText).scrollTo(step: 500);
    final paginationText = $(CommonPage($).paginationText).text;
    final proposalsDisplayedCount = paginationText?.split(' ')[0].split('-')[1];
    final proposalsCount = $.tester
        .widgetList<Material>(
          $(proposalsContainer).$(MostRecentSection($).proposalCard),
        )
        .length;
    expect(proposalsCount, int.parse(proposalsDisplayedCount!));
    expect(
      paginationText?.indexOf(T.get('proposals')),
      greaterThanOrEqualTo(1),
    );
    expect(proposalsDisplayedCount, proposalsCount.toString());

    expect($(CommonPage($).prevPageBtn).visible, true);
    expect($(CommonPage($).nextPageBtn).visible, true);
  }
}
