import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'campaign_builder_state.dart';

class CampaignBuilderCubit extends Cubit<CampaignBuilderState> {
  CampaignBuilderCubit() : super(const CampaignBuilderState(isLoading: true));

  void getCampaignStatus() {
    emit(state.copyWith(isLoading: true));

    emit(
      state.copyWith(
        isLoading: false,
        publish: const Optional(CampaignPublish.draft),
      ),
    );
  }

  void updateCampaignPublish(CampaignPublish publish) {
    emit(state.copyWith(isLoading: true));

    // TODO(LynxLynxx): call backend to update campaign status

    emit(
      state.copyWith(
        isLoading: false,
        publish: Optional(publish),
      ),
    );
  }

  void updateCampaignDates({
    required DateTime? startDate,
    required DateTime? endDate,
  }) {
    emit(state.copyWith(isLoading: true));

    // TODO(LynxLynxx): call backend to update campaign dates

    emit(
      state.copyWith(
        isLoading: false,
        startDate: Optional(startDate),
        endDate: Optional(endDate),
      ),
    );
  }
}
