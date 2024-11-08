import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'guidance_state.dart';

class GuidanceCubit extends Cubit<GuidanceState> {
  //Not sure how guidances will be passed when selection on left panel changes
  late List<Guidance> guidances;
  GuidanceCubit(this.guidances) : super(SelectedGuidances(guidances));

  void filterGuidances(GuidanceType? type) {
    if (type == null) {
      emit(SelectedGuidances(guidances));
    } else {
      final allGuidances = [...guidances];
      emit(
        SelectedGuidances(
          allGuidances.where((e) => e.type == type).toList(),
        ),
      );
    }
  }
}
