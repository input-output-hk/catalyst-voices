import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/translations_utils.dart';
import '../discovery_page.dart';

class CampaignCategoriesSection {
  CampaignCategoriesSection(this.$);

  late PatrolTester $;
  final categoriesRoot = const Key('CampaignCategoriesStateSelector');
  final categoriesTitle = const Key('CampaignCategoriesTitle');
  final campaignCategories = const Key('CampaignCategories');
  final categoryImage = const Key('CategoryImage');
  final availableFunds = const Key('AvailableFunds');
  final proposalsCount = const Key('ProposalsCount');
  final dataTitle = const Key('DataTitle');
  final dataValue = const Key('DataValue');
  final title = const Key('CategoryTitle');
  final subname = const Key('CategorySubname');
  final description = const Key('Description');
  final categoryDetailsButton = const Key('CategoryDetailsBtn');
  final viewProposalsButton = const Key('ViewProposalsBtn');
  final categoriesLoadingError = const Key('CampaignCategoriesError');

  Future<void> titleIsRenderedCorrectly() async {
    await $(categoriesTitle).scrollTo(step: 90);
    expect($(categoriesTitle).text, (await t()).campaignCategories);
  }

  Future<void> categoriesAreRenderedCorrectly() async {
    for (var i = 0; i < 6; i++) {
      try {
        $(categoriesRoot).$(campaignCategories).at(i).$(description).visible;
      } catch (e) {
        await $(categoriesRoot).$(campaignCategories).at(i).$(description).scrollTo();
      }
      expect(
        $(categoriesRoot).$(campaignCategories).at(i).$(title).$(Text).text,
        isNotEmpty,
      );
      expect(
        $(categoriesRoot).$(campaignCategories).at(i).$(subname).$(Text).text,
        isNotEmpty,
      );
      expect(
        $(categoriesRoot).$(campaignCategories).at(i).$(availableFunds).$(dataTitle).text,
        (await t()).fundsAvailable,
      );
      expect(
        $(categoriesRoot).$(campaignCategories).at(i).$(availableFunds).$(dataValue).text,
        isNotEmpty,
      );
      expect(
        $(categoriesRoot).$(campaignCategories).at(i).$(proposalsCount).$(dataTitle).text,
        (await t()).proposals,
      );
      expect(
        $(categoriesRoot).$(campaignCategories).at(i).$(proposalsCount).$(dataValue).text,
        isNotEmpty,
      );
      expect(
        $(categoriesRoot).$(campaignCategories).at(i).$(description).$(Text).text,
        isNotEmpty,
      );
      expect(
        $(categoriesRoot).$(campaignCategories).at(i).$(categoryDetailsButton).$(Text).text,
        (await t()).categoryDetails,
      );
      expect(
        $(categoriesRoot).$(campaignCategories).at(i).$(viewProposalsButton).$(Text).text,
        (await t()).viewProposals,
      );
    }
  }

  Future<void> looksAsExpectedForVisitor() async {
    await titleIsRenderedCorrectly();
    await DiscoveryPage($).loadRetryOnError(categoriesLoadingError);
    await categoriesAreRenderedCorrectly();
  }
}
