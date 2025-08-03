import 'package:catalyst_voices_models/catalyst_voices_models.dart';

enum VotingPageTab {
  total(filter: ProposalsFilterType.finals),
  favorites(filter: ProposalsFilterType.favorites),
  my(filter: ProposalsFilterType.myFinals),
  votedOn(filter: ProposalsFilterType.voted);

  final ProposalsFilterType filter;

  const VotingPageTab({required this.filter});
}
