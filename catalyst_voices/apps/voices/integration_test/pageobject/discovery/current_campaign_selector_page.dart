import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/translations_utils.dart';
import '../discovery_page.dart';

class CurrentCampaignSection {
  CurrentCampaignSection(this.$);

  late PatrolTester $;
  final currentCampaignRoot = const Key('CurrentCampaignRoot');
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
  final timelineCardDescription = const Key('TimelineCardDescription');
  final currentCampaignLoadingError = const Key('CurrentCampaignError');

  Future<void> titleIsRenderedCorrectly() async {
    await $(title).scrollTo();
    expect($(title).text, T.get('Current Campaign'));
  }

  Future<void> subtitleIsRenderedCorrectly() async {
    expect($(subtitle).text, T.get('Catalyst Fund 14'));
  }

  Future<void> descriptionIsRenderedCorrectly() async {
    await $(description).scrollTo(step: 90);
    expect(
      $(description).text,
      T.get('Project Catalyst turns economic power '
          'into innovation power by using the Cardano Treasury to incentivize '
          'and fund community-approved ideas.'),
    );
  }

  Future<void> campaignDetailsAreRenderedCorrectly() async {
    await $(fundsDetailCard).$(fundsDetailAskRangeMax).$(#Title).scrollTo();
    expect(
      $(fundsDetailCard).$(fundsDetailBudget).$(#Title).text,
      T.get('Campaign Treasury'),
    );
    expect(
      $(fundsDetailCard).$(fundsDetailBudget).$(#Description).text,
      T.get('Total budget, including ecosystem incentives'),
    );
    expect(
      $(fundsDetailCard).$(fundsDetailBudget).$(#Funds).text!.isNotEmpty,
      isTrue,
    );
    expect(
      $(fundsDetailCard).$(fundsDetailRequested).$(#Title).text,
      T.get('Campaign Total Ask'),
    );
    expect(
      $(fundsDetailCard).$(fundsDetailRequested).$(#Description).text,
      T.get('Funds requested by all submitted projects'),
    );
    expect(
      $(fundsDetailCard).$(fundsDetailRequested).$(#Funds).text!.isNotEmpty,
      isTrue,
    );
    expect(
      $(fundsDetailCard).$(fundsDetailAskRangeMax).$(#Title).text,
      T.get('Maximum Ask'),
    );
    expect(
      $(fundsDetailCard).$(fundsDetailAskRangeMax).$(#Value).text!.isNotEmpty,
      isTrue,
    );
    expect(
      $(fundsDetailCard).$(fundsDetailAskRangeMax).$(#Title).text,
      T.get('Maximum Ask'),
    );
    expect(
      $(fundsDetailCard).$(fundsDetailAskRangeMax).$(#Value).text!.isNotEmpty,
      isTrue,
    );
    await $(currentCampaignRoot).$(ideaSubTitle).scrollTo(step: 150);
    expect(
      $(currentCampaignRoot).$(ideaSubTitle).text,
      T.get('Idea Journey'),
    );
    final descriptionText = $.tester
        .widget<MarkdownBody>(
          $(currentCampaignRoot).$(ideaDescription).$(MarkdownBody),
        )
        .data;
    expect(
      descriptionText.indexOf(
        T.get(
            'Ideas comes to life in Catalyst through its key stages below. For'
            ' the full timeline, deadlines and latest updates, visit the'),
      ),
      greaterThanOrEqualTo(1),
    );
    expect($(currentCampaignRoot).$(timelineCard), findsExactly(5));
  }

  Future<void> looksAsExpectedForVisitor() async {
    await titleIsRenderedCorrectly();
    await subtitleIsRenderedCorrectly();
    await descriptionIsRenderedCorrectly();
    await DiscoveryPage($).loadRetryOnError(currentCampaignLoadingError);
    await campaignDetailsAreRenderedCorrectly();
  }

  Future<void> timelineCardsDataIsRendered() async {
    await descriptionIsRenderedCorrectly();
    await DiscoveryPage($).loadRetryOnError(currentCampaignLoadingError);
    await $(currentCampaignRoot)
        .$(timelineCard)
        .at(0)
        .$(timelineCardDate)
        .scrollTo(step: 150);
    for (var i = 0; i < 5; i++) {
      final cardTitle = $(campaignTimelineComponent)
          .$(timelineCard)
          .at(i)
          .$(timelineCardTitle);
      await $.tester.dragUntilVisible(
        cardTitle,
        $(campaignTimelineComponent).$(SingleChildScrollView),
        const Offset(10, 0),
      );
      expect(
        $(currentCampaignRoot)
            .$(timelineCard)
            .at(i)
            .$(AnimatedSwitcher)
            .$(Text),
        findsNothing,
      );
      await $(currentCampaignRoot).$(timelineCard).at(i).tap();

      var titleText = '';
      switch (i) {
        case 0:
          titleText = T.get('Proposal Submission');
          break;
        case 1:
          titleText = T.get('Community Review');
          break;
        case 2:
          titleText = T.get('Community Voting');
          break;
        case 3:
          titleText = T.get('Voting Results');
          break;
        case 4:
          titleText = T.get('Project Onboarding');
          break;
      }
      expect(
        $(currentCampaignRoot).$(timelineCard).at(i).$(timelineCardTitle).text,
        titleText,
      );
      expect(
        $(currentCampaignRoot).$(timelineCard).at(i).$(timelineCardDate).text,
        isNotEmpty,
      );
      expect(
        $(currentCampaignRoot)
            .$(timelineCard)
            .at(i)
            .$(AnimatedSwitcher)
            .$(Text)
            .text,
        isNotEmpty,
      );
    }
  }
}
