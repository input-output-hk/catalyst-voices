import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import '../../utils/translations_utils.dart';

class CurrentCampaignSelector {
  CurrentCampaignSelector(this.$);

  late PatrolTester $;
  final currentCampaignRoot = const Key('CurrentCampaign');
  final title = const Key('CurrentCampaignTitle');
  final subtitle = const Key('Subtitle');
  final description = const Key('Description');
  final fundsDetailCard = const Key('FundsDetailCard');
  final fundsDetailBudget = const Key('FundsDetailBudget');
  final fundsDetailRequested = const Key('FundsDetailRequested');
  final fundsDetailAsk = const Key('FundsDetailAsk');
  final ideaSubTitle = const Key('IdeaSubTitle');
  final campaignTimeline = const Key('CampaignTimeline');
  final timelineCardTopBar = const Key('TimelineCardTopBar');
  final timelineCardTitle = const Key('TimelineCardTitle');
  final timelineCardDate = const Key('TimelineCardDate');
  final timelineCardDescription = const Key('TimelineCardDescription');
  final loadingError = const Key('ErrorIndicator');

  Future<void> titleIsRenderedCorrectly() async {
    await $(title).scrollTo();
    expect($(title).text, T.get('Current Campaign'));
  }

  Future<void> subtitleIsRenderedCorrectly() async {
    expect($(subtitle).text, T.get('Catalyst Fund 14'));
  }

  Future<void> descriptionIsRenderedCorrectly() async {
    await $(description).scrollTo();
    expect(
      $(description).text,
      T.get('Project Catalyst turns economic power '
          'into innovation power by using the Cardano Treasury to incentivize '
          'and fund community-approved ideas.'),
    );
  }

  Future<bool> loadingErrorIsVisible() async {
    return $(currentCampaignRoot).$(loadingError).visible;
  }

  Future<void> loadingErrorClick() async {
    await $(currentCampaignRoot).$(loadingError).tap();
  }

  Future<void> loadRetryOnError() async {
    var v1 = await loadingErrorIsVisible();
    print('loadRetryOnError: $v1');
    if (await loadingErrorIsVisible()) {
      for (var i = 0; i < 5; i++) {
        await loadingErrorClick();
        await Future<void>.delayed(const Duration(seconds: 5));
        if (!(await loadingErrorIsVisible())) {
          break;
        }
      }
    }
  }

  Future<void> campaignDetailsAreRenderedCorrectly() async {
    await $(fundsDetailCard).scrollTo();
    expect(
      $(fundsDetailBudget).$(#Title).text,
      T.get('Campaign Treasury'),
    );
    // final fundsDetailCard = const Key('FundsDetailCard');
    // final fundsDetailBudget = const Key('FundsDetailBudget');
    // final fundsDetailRequested = const Key('FundsDetailRequested');
    // final fundsDetailAsk = const Key('FundsDetailAsk');
  }

  Future<void> looksAsExpectedForVisitor() async {
    await titleIsRenderedCorrectly();
    await subtitleIsRenderedCorrectly();
    await descriptionIsRenderedCorrectly();
    await loadRetryOnError();
    await campaignDetailsAreRenderedCorrectly();
  }
}
