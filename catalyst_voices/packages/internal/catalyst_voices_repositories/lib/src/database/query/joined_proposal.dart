import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:equatable/equatable.dart';

final class JoinedProposal extends Equatable {
  final DocumentEntity document;
  final DocumentEntity template;
  final DocumentEntity? action;
  final int commentsCount;

  const JoinedProposal({
    required this.document,
    required this.template,
    required this.action,
    required this.commentsCount,
  });

  @override
  List<Object?> get props => [
        document,
        template,
        action,
        commentsCount,
      ];
}
