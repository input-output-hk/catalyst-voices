import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class UsersProposalOverview extends Equatable {
  final DocumentRef selfRef;
  final String title;
  final DateTime updateDate;
  final Coin fundsRequested;
  final ProposalPublish publish;
  final List<ProposalVersionViewModel> versions;
  final int commentsCount;
  final String category;
  final SignedDocumentRef categoryId;
  final int fundNumber;

  const UsersProposalOverview({
    required this.selfRef,
    required this.title,
    required this.updateDate,
    required this.fundsRequested,
    required this.publish,
    required this.versions,
    required this.commentsCount,
    required this.category,
    required this.categoryId,
    required this.fundNumber,
  });

  factory UsersProposalOverview.fromProposal(Proposal proposal, int fundNumber) {
    return UsersProposalOverview(
      selfRef: proposal.selfRef,
      title: proposal.title,
      updateDate: proposal.updateDate,
      fundsRequested: proposal.fundsRequested,
      publish: proposal.publish,
      versions: proposal.versions.toViewModels(),
      commentsCount: proposal.commentsCount,
      category: proposal.category,
      categoryId: proposal.categoryId,
      fundNumber: fundNumber,
    );
  }

  bool get hasNewerLocalIteration {
    if (versions.isEmpty) return false;
    return versions.any((version) => version.isLatestLocal) && !publish.isLocal;
  }

  int get iteration {
    if (versions.isEmpty) return DocumentVersion.firstNumber;

    return versions.firstWhere((version) => version.selfRef == selfRef).versionNumber;
  }

  @override
  List<Object?> get props => [
        selfRef,
        title,
        updateDate,
        fundsRequested,
        publish,
        versions,
        commentsCount,
        category,
        categoryId,
        fundNumber,
      ];

  UsersProposalOverview copyWith({
    DocumentRef? selfRef,
    String? title,
    DateTime? updateDate,
    Coin? fundsRequested,
    ProposalPublish? publish,
    List<ProposalVersionViewModel>? versions,
    int? commentsCount,
    String? category,
    SignedDocumentRef? categoryId,
    int? fundNumber,
  }) {
    return UsersProposalOverview(
      selfRef: selfRef ?? this.selfRef,
      title: title ?? this.title,
      updateDate: updateDate ?? this.updateDate,
      fundsRequested: fundsRequested ?? this.fundsRequested,
      publish: publish ?? this.publish,
      versions: versions ?? this.versions,
      commentsCount: commentsCount ?? this.commentsCount,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      fundNumber: fundNumber ?? this.fundNumber,
    );
  }
}
