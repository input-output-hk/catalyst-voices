import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/translations_utils.dart';
import '../discovery_page.dart';

class CurrentCampaignSection {
  final PatrolTester $;

  final title = const Key('CurrentCampaignTitle');
  final subtitle = const Key('Subtitle');
  final description = const Key('Description');
  final fundsDetailCard = const Key('FundsDetailCard');
  final fundsDetailBudget = const Key('FundsDetailBudget');
  final fundsDetailRequested = const Key('FundsDetailRequested');
  final fundsDetailAskRangeMax = const Key('RangeMax');
  final fundsDetailAskRangeMin = const Key('RangeMin');
  final ideaSubTitle = const Key('IdeaSubTitle');
  final ideaDescription = const Key('IdeaDescription');
  final timelineCard = const Key('TimelineCard');
  final campaignTimelineComponent = const Key('CampaignTimeline');
  final timelineCardTitle = const Key('TimelineCardTitle');
  final timelineCardDate = const Key('TimelineCardDate');
  final currentCampaignLoadingError = const Key('CurrentCampaignError');

  CurrentCampaignSection(this.$);

  Future<void> campaignDetailsAreRenderedCorrectly() async {
    await $(fundsDetailCard).scrollTo();

    expect(
      $(fundsDetailCard).$(fundsDetailBudget).$(#Title).text,
      (await t()).campaignTreasury,
    );
    expect(
      $(fundsDetailCard).$(fundsDetailBudget).$(#Description).text,
      (await t()).campaignTreasuryDescription,
    );
    expect(
      $(fundsDetailCard).$(fundsDetailBudget).$(#Funds).text!.isNotEmpty,
      isTrue,
    );
    expect(
      $(fundsDetailCard).$(fundsDetailRequested).$(#Title).text,
      (await t()).campaignTotalAsk,
    );
    expect(
      $(fundsDetailCard).$(fundsDetailRequested).$(#Description).text,
      (await t()).campaignTotalAskDescription,
    );
    expect(
      $(fundsDetailCard).$(fundsDetailRequested).$(#Funds).text!.isNotEmpty,
      isTrue,
    );

    await $(ideaSubTitle).scrollTo(step: 150);
    expect($(ideaSubTitle).text, (await t()).ideaJourney);
    final descriptionText = $.tester.widget<MarkdownBody>($(ideaDescription).$(MarkdownBody)).data;
    final textToMatch = (await t())
        .ideaJourneyDescription(VoicesConstants.campaignTimeline)
        .split('#### ')[1]
        .split('[fund timeline]')[0];
    expect(descriptionText.indexOf(textToMatch), greaterThanOrEqualTo(1));
    expect($(timelineCard), findsExactly(6));
  }

  Future<void> descriptionIsRenderedCorrectly() async {
    await $(description).scrollTo(step: 90);
    expect($(description).text, (await t()).currentCampaignDescription);
  }

  Future<void> looksAsExpectedForVisitor() async {
    await titleIsRenderedCorrectly();
    await subtitleIsRenderedCorrectly();
    await descriptionIsRenderedCorrectly();
    await DiscoveryPage($).loadRetryOnError(currentCampaignLoadingError);
    await campaignDetailsAreRenderedCorrectly();
  }

  Future<void> subtitleIsRenderedCorrectly() async {
    expect($(subtitle).text?.startsWith('Catalyst Fund'), true);
  }

  Future<void> timelineCardsDataIsRendered() async {
    await descriptionIsRenderedCorrectly();
    await DiscoveryPage($).loadRetryOnError(currentCampaignLoadingError);
    await $(timelineCard).at(0).$(timelineCardDate).scrollTo(step: 150);
    for (var i = 0; i < 5; i++) {
      final cardTitle = $(campaignTimelineComponent).$(timelineCard).at(i).$(timelineCardTitle);
      await $.tester.dragUntilVisible(
        cardTitle,
        $(campaignTimelineComponent).$(SingleChildScrollView),
        const Offset(10, 0),
      );
      expect(
        $(timelineCard).at(i).$(AnimatedSwitcher).$(Text),
        findsNothing,
      );
      await $(timelineCard).at(i).tap();
      expect(
        $(timelineCard).at(i).$(timelineCardTitle).text,
        isNotEmpty,
      );
      expect(
        $(timelineCard).at(i).$(timelineCardDate).text,
        isNotEmpty,
      );
      expect(
        $(timelineCard).at(i).$(AnimatedSwitcher).$(Text).text,
        isNotEmpty,
      );
    }
  }

  Future<void> titleIsRenderedCorrectly() async {
    await $(title).scrollTo();
    expect($(title).text, (await t()).currentCampaign);
  }
}
