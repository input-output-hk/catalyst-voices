import 'package:flutter/material.dart';
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
  final timelineCard = const Key('TimelineCard');
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
    await $(description).scrollTo(step: 90, maxScrolls: 2);
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
    for (var i = 0; i < 5; i++) {
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
    }
  }

  Future<void> looksAsExpectedForVisitor() async {
    await titleIsRenderedCorrectly();
    await subtitleIsRenderedCorrectly();
    await descriptionIsRenderedCorrectly();
    await DiscoveryPage($).loadRetryOnError(currentCampaignLoadingError);
    await campaignDetailsAreRenderedCorrectly();
  }
}
