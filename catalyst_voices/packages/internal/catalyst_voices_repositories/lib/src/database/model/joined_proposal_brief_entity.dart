import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:equatable/equatable.dart';

class JoinedProposalBriefEntity extends Equatable {
  final DocumentEntityV2 proposal;

  const JoinedProposalBriefEntity({
    required this.proposal,
  });

  @override
  List<Object?> get props => [
    proposal,
  ];
}
