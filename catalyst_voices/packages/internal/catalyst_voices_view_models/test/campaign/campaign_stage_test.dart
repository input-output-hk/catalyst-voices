import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/src/campaign/campaign_stage.dart';
import 'package:test/test.dart';

void main() {
  group(CampaignStage, () {
    final campaign = Campaign(
      selfRef: SignedDocumentRef.generateFirstRef(),
      name: 'name',
      description: 'description',
      publish: CampaignPublish.draft,
      allFunds: const Coin(0),
      fundNumber: 1,
      timeline: const CampaignTimeline(phases: []),
    );

    test('draft campaign resolves to draft stage', () {
      final draftCampaign = campaign.copyWith(publish: CampaignPublish.draft);

      expect(
        CampaignStage.fromCampaign(draftCampaign),
        equals(CampaignStage.draft),
      );
    });

    test('live campaign resolves to live stage', () {
      final liveCampaign = campaign.copyWith(
        publish: CampaignPublish.published,
      );

      expect(
        CampaignStage.fromCampaign(liveCampaign),
        equals(CampaignStage.live),
      );
    });
  });
}
