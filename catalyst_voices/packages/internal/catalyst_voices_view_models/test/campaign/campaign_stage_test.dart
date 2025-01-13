import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/src/campaign/campaign_stage.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group(CampaignStage, () {
    final date = DateTime(2024, 12, 3, 12, 0);
    final campaign = Campaign(
      id: 'id',
      name: 'name',
      description: 'description',
      startDate: date,
      endDate: date,
      proposalsCount: 0,
      publish: CampaignPublish.draft,
      proposalTemplateId: const Uuid().v7(),
      proposalTemplate: const DocumentSchema(
        id: '',
        version: '',
        jsonSchema: '',
        title: '',
        description: '',
        segments: [],
        order: [],
        propertiesSchema: '',
      ),
    );

    test('draft campaign resolves to draft stage', () {
      final draftCampaign = campaign.copyWith(publish: CampaignPublish.draft);

      expect(
        CampaignStage.fromCampaign(draftCampaign, date),
        equals(CampaignStage.draft),
      );
    });

    test('scheduled campaign resolves to scheduled stage', () {
      final scheduledCampaign = campaign.copyWith(
        publish: CampaignPublish.published,
        startDate: date.plusDays(1),
        endDate: date.plusDays(2),
      );

      expect(
        CampaignStage.fromCampaign(scheduledCampaign, date),
        equals(CampaignStage.scheduled),
      );
    });

    test('live campaign resolves to live stage', () {
      final liveCampaign = campaign.copyWith(
        publish: CampaignPublish.published,
        startDate: date.minusDays(1),
        endDate: date.plusDays(2),
      );

      expect(
        CampaignStage.fromCampaign(liveCampaign, date),
        equals(CampaignStage.live),
      );
    });

    test('completed campaign resolves to completed stage', () {
      final liveCampaign = campaign.copyWith(
        publish: CampaignPublish.published,
        startDate: date.minusDays(2),
        endDate: date.minusDays(1),
      );

      expect(
        CampaignStage.fromCampaign(liveCampaign, date),
        equals(CampaignStage.completed),
      );
    });
  });
}
