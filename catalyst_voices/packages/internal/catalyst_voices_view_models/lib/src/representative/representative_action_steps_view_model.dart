import 'package:catalyst_voices_view_models/src/representative/representative_action.dart';
import 'package:equatable/equatable.dart';

final class RepresentativeActionStepsViewModel extends Equatable {
  final List<RepresentativeActionStep> representativeActions;
  final StepBackRepresentativeActionStep? additionalStep;

  const RepresentativeActionStepsViewModel({
    required this.representativeActions,
    this.additionalStep,
  });

  @override
  List<Object?> get props => [representativeActions, additionalStep];
}
