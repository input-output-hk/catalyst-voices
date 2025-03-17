import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalViewMetadata extends Equatable {
  final Profile author;
  final String? description;
  final ProposalStatus status;
  final DateTime? createdAt;
  final bool warningCreatedAt;
  final String? tag;
  final int commentsCount;
  final int fundsRequested;
  final int projectDuration;
  final int milestoneCount;

  const ProposalViewMetadata({
    required this.author,
    this.description,
    required this.status,
    required this.createdAt,
    required this.warningCreatedAt,
    this.tag,
    required this.commentsCount,
    required this.fundsRequested,
    required this.projectDuration,
    required this.milestoneCount,
  });

  @override
  List<Object?> get props => [
        author,
        description,
        status,
        createdAt,
        warningCreatedAt,
        tag,
        commentsCount,
        fundsRequested,
        projectDuration,
        milestoneCount,
      ];
}
