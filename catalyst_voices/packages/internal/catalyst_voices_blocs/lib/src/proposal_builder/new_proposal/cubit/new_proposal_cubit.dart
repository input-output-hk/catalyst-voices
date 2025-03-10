import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'new_proposal_state.dart';

class NewProposalCubit extends Cubit<NewProposalState> {
  final CampaignService _campaignService;

  NewProposalCubit(this._campaignService) : super(const NewProposalState());

  _getCampaignCategories() async {
    final categories = await _campaignService.getCampaignCategories();
    final categoriesModel = categories.
    emit(state.copyWith(categories: categories));
  }
}
