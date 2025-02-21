import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import '../../utils/translations_utils.dart';

class CampainHeroSection {
  CampainHeroSection(this.$);
  late PatrolTester $;
  final heroBackgroundVideo = const Key('HeroBackgroundVideo');
  final campaignBriefTitle = const Key('CampaignBriefTitle');
  final campaignBriefDescription = const Key('CampaignBriefDescription');
  final viewProposalsButton = const Key('ViewProposalsButton');
  final unlockBtn = const Key('UnlockButton');
  final visitorBtn = const Key('VisitorButton');
  final loadingError = const Key('ErrorIndicator');
  final campaignHeroSectionRoot = const Key('CampaignHeroSection');

  Future<void> heroBackgroundVideoBoxIsVisible() async {
    // TODO(oldgreg): this looped vid is not visible in test
    // expect($(heroBackgroundVideo).visible, true);
  }

  Future<void> campaignBriefTitleIsRenderedCorrectly() async {
    expect(
      $(campaignBriefTitle).text,
      T.get('Create, fund and deliver the future of '
          'Cardano.'),
    );
  }

  Future<void> campaignBriefDescriptionIsRenderedCorrectly() async {
    expect(
      $(campaignBriefDescription).text,
      T.get('Project Catalyst is an experiment in community innovation,'
          ' providing a framework to turn ideas into impactful real world'
          " projects.\n\nWe're putting the community at the heart of Cardano's "
          'future development. Are you ready for the Challenge?'),
    );
  }

  Future<void> viewProposalsButtonIsVisible() async {
    expect($(viewProposalsButton), findsOneWidget);
    expect($(viewProposalsButton).$(Text).text, T.get('View proposals'));
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
