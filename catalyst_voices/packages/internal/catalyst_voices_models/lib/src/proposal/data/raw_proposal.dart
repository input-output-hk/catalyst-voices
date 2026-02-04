import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

class RawProposal extends Equatable {
  final DocumentData proposal;
  final DocumentData? template;
  final List<String> versionIds;
  final int commentsCount;
  final bool isFavorite;
  final List<CatalystId> originalAuthors;

  const RawProposal({
    required this.proposal,
    required this.template,
    required this.versionIds,
    required this.commentsCount,
    required this.isFavorite,
    required this.originalAuthors,
  });

  int get iteration => versionIds.indexOf(proposal.id.ver!) + 1;

  @override
  List<Object?> get props => [
    proposal,
    template,
    versionIds,
    commentsCount,
    isFavorite,
    originalAuthors,
  ];

  RawProposal copyWith({
    DocumentData? proposal,
    Optional<DocumentData>? template,
    List<String>? versionIds,
    int? commentsCount,
    bool? isFavorite,
    List<CatalystId>? originalAuthors,
  }) {
    return RawProposal(
      proposal: proposal ?? this.proposal,
      template: template.dataOr(this.template),
      versionIds: versionIds ?? this.versionIds,
      commentsCount: commentsCount ?? this.commentsCount,
      isFavorite: isFavorite ?? this.isFavorite,
      originalAuthors: originalAuthors ?? this.originalAuthors,
    );
  }
}
