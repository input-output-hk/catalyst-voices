import 'package:catalyst_voices_models/src/campaign/campaign.dart';
import 'package:catalyst_voices_models/src/campaign/constant/f15_static_campaign_categories.dart';
import 'package:catalyst_voices_models/src/document/document_ref.dart';

/// Temporary list of campaign categories assigned to the [Campaign.fXRef].
///
/// Currently on "dev" environment there are only 3 categories non-assigned to F14 or F15.
final fXStaticCampaignCategories = [
  f15StaticCampaignCategories[0].copyWith(
    campaignRef: Campaign.fXRef,
    id: const SignedDocumentRef.first('019b4b08-6b3a-7f56-8751-c6a7fd038b97'),
  ),
  f15StaticCampaignCategories[1].copyWith(
    campaignRef: Campaign.fXRef,
    id: const SignedDocumentRef.first('019b2863-7e39-76c0-ab9d-3d78cac2da5a'),
  ),
  f15StaticCampaignCategories[2].copyWith(
    campaignRef: Campaign.fXRef,
    id: const SignedDocumentRef.first('019b2b86-7507-7b95-929e-74e3bffb030d'),
  ),
];
