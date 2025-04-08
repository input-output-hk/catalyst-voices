import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

abstract interface class ProposalsDao {
  Future<Page<JoinedProposalEntity>> queryProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
  });

  Stream<ProposalsCount> watchCount({
    required ProposalsCountFilters filters,
  });
}
