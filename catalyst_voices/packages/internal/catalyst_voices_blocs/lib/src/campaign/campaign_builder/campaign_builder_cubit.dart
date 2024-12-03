import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'campaign_builder_state.dart';

class CampaignBuilderCubit extends Cubit<CampaignBuilderState> {
  CampaignBuilderCubit() : super(const LoadingCampaignBuilderState());

  void getCampaignStatus() {
    emit(const LoadingCampaignBuilderState());

    emit(const ChangedCampaignBuilderState(CampaignPublish.draft));
  }

  void updateCampaignStatus(CampaignPublish newStatus) {
    emit(const LoadingCampaignBuilderState());
    // TODO(ryszard-schossler): call backend to update campaign status

    emit(ChangedCampaignBuilderState(newStatus));
  }

  CampaignPublish? get campaignStatus => switch (state) {
        LoadingCampaignBuilderState() => null,
        ChangedCampaignBuilderState(:final status) => status,
      };
}
