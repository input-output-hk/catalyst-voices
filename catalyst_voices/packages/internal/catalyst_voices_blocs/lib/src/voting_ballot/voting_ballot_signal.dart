import 'package:equatable/equatable.dart';

final class HideBottomSheetSignal extends VotingBallotSignal {
  const HideBottomSheetSignal();
}

final class ShowBottomSheetSignal extends VotingBallotSignal {
  const ShowBottomSheetSignal();
}

sealed class VotingBallotSignal extends Equatable {
  const VotingBallotSignal();

  @override
  List<Object?> get props => [];
}
