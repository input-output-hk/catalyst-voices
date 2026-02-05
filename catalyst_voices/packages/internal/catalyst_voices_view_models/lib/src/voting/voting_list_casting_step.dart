import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ConfirmPasswordStep extends VotingListCastingStep {
  final bool isLoading;
  final bool isRepresentative;
  final LocalizedException? exception;

  const ConfirmPasswordStep({
    this.isLoading = false,
    this.isRepresentative = false,
    this.exception,
  });

  @override
  List<Object?> get props => [
    isLoading,
    isRepresentative,
    exception,
  ];

  ConfirmPasswordStep copyWith({
    bool? isLoading,
    bool? isRepresentative,
    Optional<LocalizedException>? exception,
  }) {
    return ConfirmPasswordStep(
      isLoading: isLoading ?? this.isLoading,
      isRepresentative: isRepresentative ?? this.isRepresentative,
      exception: exception.dataOr(this.exception),
    );
  }
}

final class FailedToCastVotesStep extends VotingListCastingStep {
  const FailedToCastVotesStep();
}

final class PreCastVotesStep extends VotingListCastingStep {
  const PreCastVotesStep();
}

final class SuccessfullyCastVotesStep extends VotingListCastingStep {
  const SuccessfullyCastVotesStep();
}

sealed class VotingListCastingStep extends Equatable {
  const VotingListCastingStep();

  @override
  List<Object?> get props => [];
}
