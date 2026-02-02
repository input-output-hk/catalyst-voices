import 'package:catalyst_voices_models/src/campaign/campaign.dart';
import 'package:catalyst_voices_models/src/campaign/constant/f15_static_campaign_categories.dart';
import 'package:catalyst_voices_models/src/document/document_ref.dart';

/// Default category UUIDs (used when dart-define values are not provided).
const _defaultCategory0 = '019b4b08-6b3a-7f56-8751-c6a7fd038b97';
const _defaultCategory1 = '019b2863-7e39-76c0-ab9d-3d78cac2da5a';
const _defaultCategory2 = '019b2b86-7507-7b95-929e-74e3bffb030d';

/// Category UUIDs from dart-define or defaults.
/// These can be overridden at build time via:
///   --dart-define=FUND_CATEGORY_0=<uuid>
///   --dart-define=FUND_CATEGORY_1=<uuid>
///   --dart-define=FUND_CATEGORY_2=<uuid>
const _category0 = String.fromEnvironment(
  'FUND_CATEGORY_0',
  defaultValue: _defaultCategory0,
);
const _category1 = String.fromEnvironment(
  'FUND_CATEGORY_1',
  defaultValue: _defaultCategory1,
);
const _category2 = String.fromEnvironment(
  'FUND_CATEGORY_2',
  defaultValue: _defaultCategory2,
);

/// Temporary list of campaign categories assigned to the [Campaign.fXRef].
///
/// For local/e2e testing, the category UUIDs can be configured via dart-define.
/// Run `setup_fund.py local` from signed_docs to generate new UUIDs and
/// output them to `catalyst_voices/apps/voices/.env`.
final fXStaticCampaignCategories = [
  f15StaticCampaignCategories[0].copyWith(
    campaignRef: Campaign.fXRef,
    id: const SignedDocumentRef.first(_category0),
  ),
  f15StaticCampaignCategories[1].copyWith(
    campaignRef: Campaign.fXRef,
    id: const SignedDocumentRef.first(_category1),
  ),
  f15StaticCampaignCategories[2].copyWith(
    campaignRef: Campaign.fXRef,
    id: const SignedDocumentRef.first(_category2),
  ),
];
