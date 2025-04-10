import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:equatable/equatable.dart';

final class JoinedProposalEntity extends Equatable {
  final DocumentEntity proposal;
  final DocumentEntity template;

  const JoinedProposalEntity({
    required this.proposal,
    required this.template,
  });

  @override
  List<Object?> get props => [
        proposal,
        template,
      ];
}
