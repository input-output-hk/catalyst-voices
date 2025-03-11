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

  final errorRetryBtn = const Key('ErrorRetryBtn');

  Future<void> looksAsExpectedForVisitor() async {
    await AppBarPage($).looksAsExpectedForVisitor();
    await CampaignHeroSection($).looksAsExpectedForVisitor();
    await HowItWorksSection($).looksAsExpectedForVisitor();
    await CurrentCampaignSection($).looksAsExpectedForVisitor();
    await CampaignCategoriesSection($).looksAsExpectedForVisitor();
    await MostRecentSection($).looksAsExpectedForVisitor();
  }

  Future<void> viewProposalsBtnClick() async {
    await $(CampaignHeroSection($).viewProposalsButton).tap();
  }

  Future<bool> loadingErrorIsVisible(Key errorSelector) async {
    try {
      expect(
        !$.tester.widget<Offstage>($(errorSelector)).offstage,
        true,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> loadingErrorClick(Key errorSelector) async {
    await $(errorSelector).$(errorRetryBtn).tap();
  }

  Future<void> loadRetryOnError(Key errorSelector) async {
    if (await loadingErrorIsVisible(errorSelector)) {
      var i = 0;
      for (i = 0; i < 5; i++) {
        await loadingErrorClick(errorSelector);
        await Future<void>.delayed(const Duration(seconds: 5));
        if (!(await loadingErrorIsVisible(errorSelector))) {
          break;
        } else if (i == 4) {
          throw Exception('Max ${i - 1} retries exceeded');
        }
      }
    }
  }
}
