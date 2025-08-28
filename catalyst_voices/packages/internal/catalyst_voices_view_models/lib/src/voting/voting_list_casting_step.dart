import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ConfirmPasswordStep extends VotingListCastingStep {
  final bool isLoading;
  final LocalizedException? exception;

  const ConfirmPasswordStep({
    this.isLoading = false,
    this.exception,
  });

  @override
  List<Object?> get props => [isLoading, exception];

  ConfirmPasswordStep copyWith({
    bool? isLoading,
    Optional<LocalizedException>? exception,
  }) {
    return ConfirmPasswordStep(
      isLoading: isLoading ?? this.isLoading,
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
