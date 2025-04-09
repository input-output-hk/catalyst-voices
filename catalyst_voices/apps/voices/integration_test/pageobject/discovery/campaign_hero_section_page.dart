import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/translations_utils.dart';

class CampaignHeroSection {
  CampaignHeroSection(this.$);
  late PatrolTester $;
  final heroBackgroundVideo = const Key('HeroBackgroundVideo');
  final campaignBriefTitle = const Key('CampaignBriefTitle');
  final campaignBriefDescription = const Key('CampaignBriefDescription');
  final viewProposalsButton = const Key('ViewProposalsBtn');
  final unlockBtn = const Key('UnlockButton');
  final visitorBtn = const Key('VisitorBtn');
  final loadingError = const Key('ErrorIndicator');
  final campaignHeroSectionRoot = const Key('CampaignHeroSection');

  Future<void> heroBackgroundVideoBoxIsVisible() async {
    // TODO(oldgreg): this looped vid is not visible in test
    // expect($(heroBackgroundVideo).visible, true);
  }

  Future<void> campaignBriefTitleIsRenderedCorrectly() async {
    expect(
      $(campaignBriefTitle).text,
      (await t()).heroSectionTitle,
    );
  }

  Future<void> campaignBriefDescriptionIsRenderedCorrectly() async {
    expect(
      $(campaignBriefDescription).text,
      (await t()).projectCatalystDescription,
    );
  }

  Future<void> viewProposalsButtonIsVisible() async {
    expect($(viewProposalsButton), findsOneWidget);
    expect($(viewProposalsButton).$(Text).text, (await t()).viewProposals);
  }

  Future<void> loadingErrorIsVisible() async {
    expect($(campaignHeroSectionRoot).$(loadingError), findsOneWidget);
  }

  Future<void> looksAsExpectedForVisitor() async {
    await heroBackgroundVideoBoxIsVisible();
    await campaignBriefTitleIsRenderedCorrectly();
    await campaignBriefDescriptionIsRenderedCorrectly();
    await viewProposalsButtonIsVisible();
  }
}
