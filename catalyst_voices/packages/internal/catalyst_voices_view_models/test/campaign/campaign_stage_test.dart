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
      allFunds: MultiCurrencyAmount.single(
        Money.zero(currency: const Currency.ada()),
      ),
      totalAsk: MultiCurrencyAmount.single(
        Money.zero(currency: const Currency.ada()),
      ),
      fundNumber: 1,
      timeline: const CampaignTimeline(phases: []),
      categories: const [],
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
