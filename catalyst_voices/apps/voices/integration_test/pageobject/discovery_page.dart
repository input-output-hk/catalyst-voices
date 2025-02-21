import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import 'app_bar_page.dart';
import 'discovery/campaign_categories_section.dart';
import 'discovery/campaign_hero_section_page.dart';
import 'discovery/current_campaign_selector_page.dart';
import 'discovery/how_it_works_section_page.dart';
import 'discovery/most_recent_section.dart';

class DiscoveryPage {
  DiscoveryPage(this.$);
  late PatrolTester $;
  final loadingError = const Key('ErrorIndicator');

  Future<void> looksAsExpectedForVisitor() async {
    await AppBarPage($).looksAsExpectedForVisitor();
    await CampainHeroSection($).looksAsExpectedForVisitor();
    await HowItWorksSection($).looksAsExpectedForVisitor();
    await CurrentCampaignSelector($).looksAsExpectedForVisitor();
    await CampaignCategoriesSection($).looksAsExpectedForVisitor();
    await MostRecentSection($).looksAsExpectedForVisitor();
  }
}
