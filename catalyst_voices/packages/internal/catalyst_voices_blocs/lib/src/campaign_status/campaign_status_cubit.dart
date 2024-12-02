import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'campaign_status_state.dart';

class CampaignStatusCubit extends Cubit<CampaignStatusState> {
  CampaignStatusCubit() : super(LoadingCampaignStatusState());

  void getCampaignStatus() {
    emit(LoadingCampaignStatusState());

    emit(const ChangedCampaignStatusState(CampaignStatus.draft));
  }

  void updateCampaignStatus(CampaignStatus newStatus) {
    emit(LoadingCampaignStatusState());
    // TODO(ryszard-schossler): call backend to update campaign status

    emit(ChangedCampaignStatusState(newStatus));
  }

  CampaignStatus? get campaignStatus => switch (state) {
        LoadingCampaignStatusState() => null,
        ChangedCampaignStatusState(:final status) => status,
      };
}
