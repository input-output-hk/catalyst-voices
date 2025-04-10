import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:equatable/equatable.dart';

final class JoinedProposalEntity extends Equatable {
  final DocumentEntity proposal;
  final DocumentEntity template;
  final DocumentEntity? action;
  final int commentsCount;
  final List<String> versions;

  const JoinedProposalEntity({
    required this.proposal,
    required this.template,
    this.action,
    this.commentsCount = 0,
    this.versions = const [],
  });

  @override
  List<Object?> get props => [
        proposal,
        template,
        action,
        commentsCount,
        versions,
      ];
}
