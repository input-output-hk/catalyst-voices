import 'package:catalyst_voices_models/catalyst_voices_models.dart';

enum ProposalsPageTab {
  total(filter: ProposalsFilterType.total),
  drafts(filter: ProposalsFilterType.drafts),
  finals(filter: ProposalsFilterType.finals),
  favorites(filter: ProposalsFilterType.favorites),
  my(filter: ProposalsFilterType.my);

  final ProposalsFilterType filter;

  const ProposalsPageTab({required this.filter});
}
