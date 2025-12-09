import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalDataV2 extends Equatable {
  final DocumentRef id;
  // This can be retrive from ProposalOrDocument
  final ProposalDocument document;
  // Maybe at here nullable template
  final bool isFavorite;
  final String categoryName;
  final ProposalBriefDataVotes? votes;
  final List<ProposalBriefDataVersion>? versions;
  final List<ProposalBriefDataCollaborator>? collaborators;
  // Consider adding more campaign or category data here

  const ProposalDataV2({
    required this.id,
    required this.document,
    required this.isFavorite,
    required this.categoryName,
    this.votes,
    this.versions,
    this.collaborators,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
