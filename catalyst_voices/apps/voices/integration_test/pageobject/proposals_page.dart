import 'package:catalyst_voices/widgets/search/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../utils/mock_url_launcher_platform.dart';
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
  final shareProposalDialog = const Key('ShareProposalDialog');
  final closeButton = const Key('CloseButton');
  final shareItem = const Key('ShareItem');
  final itemIcon = const Key('ItemIcon');
  final itemTitle = const Key('ItemTitle');
  final itemDescription = const Key('ItemDescription');

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
    expect($(CommonPage($).navigationBackBtn).$(Text).text, (await t()).back);
  }

  Future<void> clickBackButton() async {
    await $(CommonPage($).navigationBackBtn).tap();
  }

  Future<void> currentCampaignDetailsLooksAsExpected() async {
    expect(
      $(currentCampaignTitle).text?.startsWith('Catalyst Fund '),
      true,
    );
    expect($(currentCampaignDescription).text, isNotEmpty);
    expect($(campaignDetailsButton).$(Text).text, (await t()).campaignDetails);
  }

  Future<void> proposalsTabsLookAsExpected() async {
    expect(
      $(allProposalsTab)
          .$(Text)
          .text
          ?.startsWith((await t()).noOfAll(0).split('(')[0]),
      true,
    );
    expect(
      $(draftProposalsTab)
          .$(Text)
          .text
          ?.startsWith((await t()).noOfDraft(0).split('(')[0]),
      true,
    );
    expect(
      $(finalProposalsTab)
          .$(Text)
          .text
          ?.startsWith((await t()).noOfFinal(0).split('(')[0]),
      true,
    );
    expect(
      $(favoriteProposalsTab)
          .$(Text)
          .text
          ?.startsWith((await t()).noOfFavorites(0).split('(')[0]),
      true,
    );
    expect(
      $(myProposalsTab)
          .$(Text)
          .text
          ?.startsWith((await t()).noOfMyProposals(0).split('(')[0]),
      true,
    );
  }

  Future<void> changeCategoriesBtnLooksAsExpected() async {
    expect($(categorySelectorLabel).text, (await t()).category);
    expect($(categorySelectorValue).text, (await t()).showAll);
  }

  Future<void> searchFieldLooksAsExpected() async {
    final searchHintText =
        $.tester.widget<SearchTextField>($(searchProposalsField)).hintText;
    expect(searchHintText, (await t()).searchProposals);
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
      // TODO(oldgreg): Fix this with translations after #2027 is done
      paginationText?.indexOf('proposals'),
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
    expect($(titleLabelText).text, (await t()).campaign);
    expect($(titleText).text, isNotEmpty);
    expect($(campaignDetailsTitleLabel).text, (await t()).campaignDetails);
    expect($(campaignDetailsTile).$(animatedExpandChevron), findsOneWidget);
    expect($(descriptionTileKey).text, (await t()).description);
    expect($(descriptionTextKey).text, isNotEmpty);
    expect($(startDateTileKey).$(title).text, (await t()).startDate);
    expect($(startDateTileKey).$(subtitle).text, isNotEmpty);
    expect(
      int.parse($(startDateTileKey).$(value).text!),
      inInclusiveRange(0, 31),
    );
    expect($(startDateTileKey).$(suffix).text, isNotEmpty);
    expect($(endDateTileKey).$(title).text, (await t()).endDate);
    expect($(endDateTileKey).$(subtitle).text, isNotEmpty);
    expect(
      int.parse($(endDateTileKey).$(value).text!),
      inInclusiveRange(0, 31),
    );
    expect($(endDateTileKey).$(suffix).text, isNotEmpty);
    expect($(categoriesTileKey).$(title).text, (await t()).categories);
    expect($(categoriesTileKey).$(subtitle).text, isNotEmpty);
    expect(
      int.parse($(categoriesTileKey).$(value).text!),
      inInclusiveRange(0, 31),
    );
    expect($(proposalsTileKey).$(title).text, (await t()).proposals);
    expect($(proposalsTileKey).$(subtitle).text, isNotEmpty);
    expect(
      int.parse($(proposalsTileKey).$(value).text!),
      inInclusiveRange(0, 31),
    );
    expect(
      $(campaignCategoriesTitleLabel).text,
      (await t()).campaignCategories,
    );
    expect($(cardanoUseCasesLabel).text, (await t()).cardanoUseCases);
    final useCasesItemsCount = $.tester
        .widgetList<InkWell>(
          $(campaignCategoriesMenu).$(InkWell),
        )
        .length;
    for (var i = 1; i <= useCasesItemsCount; i++) {
      final item = $(Key('VoicesModalMenu[$i]Key')).$(Text);
      await item.scrollTo();
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
        expectedStage,
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

  Future<void> proposalLinksAreWorkingFor(int proposalNumber) async {
    await $(proposalsContainer)
        .$(MostRecentSection($).proposalCard)
        .at(proposalNumber)
        .$(MostRecentSection($).shareButton)
        .tap();
    final textToMatch = (await t()).shareType((await t()).proposal);
    expect($(shareProposalDialog).$(title).text, textToMatch);
    for (var i = 0; i < 5; i++) {
      expect(
        $(shareProposalDialog).$(shareItem).at(i).$(itemIcon),
        findsOneWidget,
      );
      expect(
        $(shareProposalDialog).$(shareItem).at(i).$(itemTitle).text,
        isNotEmpty,
      );
      expect(
        $(shareProposalDialog).$(shareItem).at(i).$(itemDescription).text,
        isNotEmpty,
      );
      await checkOpeningLinkByMocking(i);
    }
  }

  Future<void> checkOpeningLinkByMocking(int proposalNumber) async {
    final linkTitleText = $(shareProposalDialog)
        .$(shareItem)
        .at(proposalNumber)
        .$(itemTitle)
        .text;
    if (linkTitleText!.contains((await t()).copyLink) == false) {
      final mockUrlLauncherPlatform = MockUrlLauncherPlatform();
      final linkPartialTextToMatch =
          'https://${linkTitleText.split(' ').last.toLowerCase()}.com';
      await $(shareProposalDialog).$(shareItem).at(proposalNumber).tap();
      expect(
        mockUrlLauncherPlatform.capturedUrl.startsWith(linkPartialTextToMatch),
        true,
        reason: 'Link URL does not match the expected URL',
      );
      mockUrlLauncherPlatform.tearDownMock();
    }
  }

  Future<void> shareModalCloseButtonWorks() async {
    await $(proposalsContainer)
        .$(MostRecentSection($).proposalCard)
        .at(0)
        .$(MostRecentSection($).shareButton)
        .tap();
    expect($(shareProposalDialog).$(closeButton), findsOneWidget);
    await $(shareProposalDialog).$(closeButton).tap();
    expect($(shareProposalDialog).$(closeButton), findsNothing);
  }
}
