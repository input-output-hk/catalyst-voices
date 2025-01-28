import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'most_recent_state.dart';

class MostRecentCubit extends Cubit<MostRecentState> {
  // ignore: unused_field
  final CampaignService _campaignService;
  MostRecentCubit(this._campaignService) : super(const LoadingMostRecent());

  Future<void> loadMostRecentProposals() async {
    if (state is! LoadingMostRecent) {
      emit(const LoadingMostRecent());
    }

    // TODO(LynxxLynx): implement fetching most recent proposals

    final isSuccess = await Future.delayed(
      const Duration(seconds: 2),
      () => Random().nextBool(),
    );

    final proposals = isSuccess
        ? List.filled(7, PendingProposal.dummy())
        : const <PendingProposal>[];

    final LocalizedException? error =
        isSuccess ? null : const LocalizedUnknownException();

    if (error != null) {
      return emit(ErrorMostRecent(exception: error));
    }

    emit(LoadedMostRecent(proposals: proposals));
  }
}
