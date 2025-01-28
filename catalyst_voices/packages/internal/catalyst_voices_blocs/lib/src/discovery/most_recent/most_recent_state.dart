part of 'most_recent_cubit.dart';

@immutable
sealed class MostRecentState extends Equatable {
  const MostRecentState();
}

final class LoadingMostRecent extends MostRecentState {
  const LoadingMostRecent();
  @override
  List<Object?> get props => [];
}

final class LoadedMostRecent extends MostRecentState {
  final List<PendingProposal> proposals;

  const LoadedMostRecent({required this.proposals});

  @override
  List<Object?> get props => [proposals];
}

final class ErrorMostRecent extends MostRecentState {
  final LocalizedException exception;

  const ErrorMostRecent({required this.exception});

  @override
  List<Object?> get props => [exception];
}
