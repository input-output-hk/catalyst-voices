import 'package:bloc_test/bloc_test.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group(CampaignInfoCubit, () {
    late Campaign campaign;
    late CampaignStage campaignStage;

    late CampaignService campaignService;
    late AdminToolsCubit adminToolsCubit;

    setUpAll(() {
      final proposalTemplate = DocumentSchema(
        id: const Uuid().v7(),
        version: const Uuid().v7(),
        jsonSchema: '',
        title: '',
        description: '',
        segments: const [],
        order: const [],
        propertiesSchema: '',
      );

      campaign = Campaign(
        id: 'campaign-id',
        name: 'name',
        description: 'description',
        startDate: DateTime.now(),
        endDate: DateTime.now().plusDays(2),
        proposalsCount: 0,
        publish: CampaignPublish.draft,
        proposalTemplateId: const Uuid().v7(),
        proposalTemplate: proposalTemplate,
      );

      campaignStage = CampaignStage.fromCampaign(
        campaign,
        DateTimeExt.now(),
      );
    });

    setUp(() {
      campaignService = _FakeCampaignService(campaign);
      adminToolsCubit = AdminToolsCubit();
    });

    blocTest<CampaignInfoCubit, CampaignInfoState>(
      'load should fetch the active campaign',
      build: () => CampaignInfoCubit(campaignService, adminToolsCubit),
      act: (cubit) async => cubit.load(),
      verify: (cubit) {
        expect(campaignStage, equals(CampaignStage.draft));
        expect(
          cubit.state.campaign?.stage,
          equals(campaignStage),
        );
      },
    );

    blocTest<CampaignInfoCubit, CampaignInfoState>(
      'load should work when there is no active campaign',
      build: () => CampaignInfoCubit(
        _FakeCampaignService(null),
        adminToolsCubit,
      ),
      act: (cubit) async => cubit.load(),
      verify: (cubit) {
        expect(cubit.state.campaign, isNull);
      },
    );

    blocTest<CampaignInfoCubit, CampaignInfoState>(
      'given admin tools enabled should not override '
      'campaign stage if campaign already has this stage',
      build: () => CampaignInfoCubit(campaignService, adminToolsCubit),
      act: (cubit) {
        adminToolsCubit.emit(
          AdminToolsState(
            enabled: true,
            campaignStage: campaignStage,
          ),
        );
      },
      verify: (cubit) {
        expect(campaignStage, equals(CampaignStage.draft));
        expect(
          cubit.state.campaign?.stage,
          equals(campaignStage),
        );
      },
    );

    blocTest<CampaignInfoCubit, CampaignInfoState>(
      'given admin tools enabled should override campaign stage',
      build: () => CampaignInfoCubit(campaignService, adminToolsCubit),
      act: (cubit) {
        adminToolsCubit.emit(
          const AdminToolsState(
            enabled: true,
            campaignStage: CampaignStage.completed,
          ),
        );
      },
      verify: (cubit) {
        expect(
          cubit.state.campaign?.stage,
          equals(CampaignStage.completed),
        );
      },
    );
  });
}

class _FakeCampaignService extends Fake implements CampaignService {
  final Campaign? _campaign;

  _FakeCampaignService(this._campaign);

  @override
  Future<Campaign?> getActiveCampaign() async {
    return _campaign;
  }
}
