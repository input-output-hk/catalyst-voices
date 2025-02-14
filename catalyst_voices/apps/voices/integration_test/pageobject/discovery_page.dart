import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import 'app_bar_page.dart';
import 'discovery/campainHeroSection_page.dart';
import 'discovery/currentCampaignSelector_page.dart';
import 'discovery/howItWorksSection_page.dart';

class DiscoveryPage {
  DiscoveryPage(this.$);
  late PatrolTester $;
  final loadingError = const Key('ErrorIndicator');

  Future<void> looksAsExpectedForVisitor() async {
    await AppBarPage($).looksAsExpectedForVisitor();
    await CampainHeroSection($).looksAsExpectedForVisitor();
    await HowItWorksSection($).looksAsExpectedForVisitor();
    await CurrentCampaignSelector($).looksAsExpectedForVisitor();
    // await CampainCategoriesStateSelector($).looksAsExpectedForVisitor();
    // await MostRecentproposalsSelector($).looksAsExpectedForVisitor();
  }

}
