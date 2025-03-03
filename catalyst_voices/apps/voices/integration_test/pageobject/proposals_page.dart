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
  final campaignDetailsCloseButton = const Key('CloseButton');
  final titleLabelText = const Key('TitleLabelText');
  final titleText = const Key('TitleText');
  final campaignDetailsTile = const Key('CampaignDetailsTile');
  final campaignDetailsTitleLabel = const Key('CampaignDetailsTitleLabel');
  final animatedExpandChevron = const Key('AnimatedExpandChevron');
  final descriptionTileKey = const Key('DescriptionTileKey');
  final descriptionTextKey = const Key('DescriptionTextKey');
  final startDateTileKey = const Key('StartDateTileKey');
  final endDateTileKey = const Key('EndDateTileKey');
  final categoriesTileKey = const Key('CategoriesTileKey');
  final proposalsTileKey = const Key('ProposalsTileKey');
  final title = const Key('Title');
  final subtitle = const Key('Subtitle');
  final value = const Key('Value');
  final suffix = const Key('Suffix');
  final campaignCategoriesTitleLabel =
      const Key('CampaignCategoriesTitleLabel');
  final campaignCategoriesMenu = const Key('CampaignCategoriesMenu');
  final cardanoUseCasesLabel = const Key('CardanoUseCasesLabel');
  final cardanoUseCasesSectionLabel = const Key('CardanoUseCasesSectionLabel');
  final cardanoUseCasesSectionTitle = const Key('CardanoUseCasesSectionTitle');
  final cardanoUseCasesSectionBody = const Key('CardanoUseCasesSectionBody');
  final emptyProposals = const Key('EmptyProposals');

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
          $(proposalsContainer).$(MostRecentSection($).proposalCard),
        )
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

  Future<void> campaignDetailsButtonWorks() async {
    await $(campaignDetailsButton).tap();
    expect($(titleLabelText), findsOneWidget);
  }

  Future<void> campaignDetailsScreenLooksAsExpected() async {
    await $(campaignDetailsButton).tap();
    expect($(titleLabelText).text, T.get('Campaign'));
    expect($(titleText).text, isNotEmpty);
    expect($(campaignDetailsTitleLabel).text, T.get('Campaign Details'));
    expect($(campaignDetailsTile).$(animatedExpandChevron), findsOneWidget);
    expect($(descriptionTileKey).text, T.get('Description'));
    expect($(descriptionTextKey).text, isNotEmpty);
    expect($(startDateTileKey).$(title).text, T.get('Start Date'));
    expect($(startDateTileKey).$(subtitle).text, isNotEmpty);
    expect(
      int.parse($(startDateTileKey).$(value).text!),
      inInclusiveRange(0, 31),
    );
    expect($(startDateTileKey).$(suffix).text, isNotEmpty);
    expect($(endDateTileKey).$(title).text, T.get('End Date'));
    expect($(endDateTileKey).$(subtitle).text, isNotEmpty);
    expect(
      int.parse($(endDateTileKey).$(value).text!),
      inInclusiveRange(0, 31),
    );
    expect($(endDateTileKey).$(suffix).text, isNotEmpty);
    expect($(categoriesTileKey).$(title).text, T.get('Categories'));
    expect($(categoriesTileKey).$(subtitle).text, isNotEmpty);
    expect(
      int.parse($(categoriesTileKey).$(value).text!),
      inInclusiveRange(0, 31),
    );
    expect($(proposalsTileKey).$(title).text, T.get('Proposals'));
    expect($(proposalsTileKey).$(subtitle).text, isNotEmpty);
    expect(
      int.parse($(proposalsTileKey).$(value).text!),
      inInclusiveRange(0, 31),
    );
    expect(
      $(campaignCategoriesTitleLabel).text,
      T.get('Campaign'
          ' Categories'),
    );
    expect($(cardanoUseCasesLabel).text, T.get('Cardano Use Cases'));
    final useCasesItemsCount = $.tester
        .widgetList<InkWell>(
          $(campaignCategoriesMenu).$(InkWell),
        )
        .length;
    for (var i = 1; i <= useCasesItemsCount; i++) {
      final item = $(Key('VoicesModalMenu[$i]Key')).$(Text);
      await $(item).tap();
      expect(
        item.text,
        isNotEmpty,
      );
      expect($(cardanoUseCasesSectionLabel).text, item.text);
      expect($(cardanoUseCasesSectionTitle).text, isNotEmpty);
      expect($(cardanoUseCasesSectionBody).text, isNotEmpty);
    }
  }

  Future<void> campaignDetailsCloseButtonWorks() async {
    await $(campaignDetailsButton).tap();
    expect($(titleLabelText), findsOneWidget);
    await $(campaignDetailsCloseButton).tap();
    expect($(titleLabelText), findsNothing);
  }

  Future<void> clickDraftTab() async {
    await $(draftProposalsTab).tap();
  }

  Future<void> clickFinalTab() async {
    await $(finalProposalsTab).tap();
  }

  Future<void> checkProposalsStageMatch(String expectedStage) async {
    final proposalsCount = $.tester
        .widgetList<Material>(
          $(proposalsContainer).$(MostRecentSection($).proposalCard),
        )
        .length;
    for (var cardIndex = 0; cardIndex < proposalsCount; cardIndex++) {
      await $(#ProposalStage).at(cardIndex).scrollTo();
      expect(
        $(#ProposalStage).at(cardIndex).text,
        T.get(expectedStage),
      );
    }
  }

  Future<void> paginationWorks() async {
    await $(CommonPage($).paginationText).scrollTo(step: 500);
    final paginationText = $(CommonPage($).paginationText).text!;
    final proposalsFrom = int.parse(paginationText.split(' ')[0].split('-')[0]);
    final proposalsTo = int.parse(paginationText.split(' ')[0].split('-')[1]);
    final proposalsTotal = int.parse(paginationText.split(' ')[2]);
    expect(proposalsFrom, 1);
    expect(
      $.tester
          .widget<IconButton>($(CommonPage($).prevPageBtn).$(IconButton))
          .onPressed,
      null,
    );
    if (proposalsTotal > proposalsTo) {
      await $(CommonPage($).nextPageBtn).tap();
      await $(CommonPage($).paginationText).scrollTo(step: 500);
      final paginationTextAfter = $(CommonPage($).paginationText).text!;
      final proposalsFromAfter =
          int.parse(paginationTextAfter.split(' ')[0].split('-')[0]);
      final proposalsToAfter =
          int.parse(paginationTextAfter.split(' ')[0].split('-')[1]);
      expect(proposalsFromAfter, proposalsTo + 1);
      expect(
        $.tester
            .widget<IconButton>($(CommonPage($).prevPageBtn).$(IconButton))
            .onPressed,
        isNotNull,
      );
      if (proposalsTotal > proposalsToAfter) {
        expect(proposalsToAfter, proposalsTo * 2);
        expect(
          $.tester
              .widget<IconButton>($(CommonPage($).nextPageBtn).$(IconButton))
              .onPressed,
          isNotNull,
        );
      } else {
        expect(proposalsToAfter, proposalsTotal);
        expect(
          $.tester
              .widget<IconButton>($(CommonPage($).nextPageBtn).$(IconButton))
              .onPressed,
          null,
        );
      }
    }
  }

  Future<int> getProposalsCountFromTab(String tab) async {
    const allowedStrings = ['All', 'Draft', 'Final', 'Favorite', 'My'];
    if (allowedStrings.contains(tab)) {
      return int.parse(
        $(Key('${tab}ProposalsTab')).$(Text).text!.split('(')[1].split(')')[0],
      );
    } else {
      throw ArgumentError('Invalid tab name: $tab');
    }
  }

  Future<void> proposalsCountIs(String tab, int count) async {
    final proposalsCountFromTab = await getProposalsCountFromTab(tab);
    expect(proposalsCountFromTab, count);
    await $(Key('${tab}ProposalsTab')).tap();
    if (count == 0) {
      expect($(emptyProposals), findsOneWidget);
    } else {
      final proposalsCount = $.tester
          .widgetList<Material>(
            $(proposalsContainer).$(MostRecentSection($).proposalCard),
          )
          .length;
      expect(proposalsCount, count);
    }
  }

  Future<void> proposalFavoriteBtnTap(int proposalNumber) async {
    await $(proposalsContainer)
        .$(MostRecentSection($).proposalCard)
        .at(proposalNumber)
        .$(MostRecentSection($).favoriteButton)
        .tap();
  }
}
