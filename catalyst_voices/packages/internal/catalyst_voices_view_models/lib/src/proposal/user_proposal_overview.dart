import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class UsersProposalOverview extends Equatable {
  final DocumentRef selfRef;
  final DocumentParameters parameters;
  final String title;
  final DateTime updateDate;
  final Money fundsRequested;
  final ProposalPublish publish;
  final List<ProposalVersionViewModel> versions;
  final int commentsCount;
  final String category;
  final int fundNumber;
  final bool fromActiveCampaign;

  const UsersProposalOverview({
    required this.selfRef,
    required this.parameters,
    required this.title,
    required this.updateDate,
    required this.fundsRequested,
    required this.publish,
    required this.versions,
    required this.commentsCount,
    required this.category,
    required this.fundNumber,
    required this.fromActiveCampaign,
  });

  factory UsersProposalOverview.fromProposal(
    DetailProposal proposal,
    int fundNumber,
    String categoryName, {
    required bool fromActiveCampaign,
  }) {
    return UsersProposalOverview(
      selfRef: proposal.selfRef,
      parameters: proposal.parameters,
      title: proposal.title,
      updateDate: proposal.updateDate,
      fundsRequested: proposal.fundsRequested,
      publish: proposal.publish,
      versions: proposal.versions.toViewModels(),
      commentsCount: proposal.commentsCount,
      category: categoryName,
      fundNumber: fundNumber,
      fromActiveCampaign: fromActiveCampaign,
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
    parameters,
    title,
    updateDate,
    fundsRequested,
    publish,
    versions,
    commentsCount,
    category,
    fundNumber,
    fromActiveCampaign,
  ];

  UsersProposalOverview copyWith({
    DocumentRef? selfRef,
    DocumentParameters? parameters,
    String? title,
    DateTime? updateDate,
    Money? fundsRequested,
    ProposalPublish? publish,
    List<ProposalVersionViewModel>? versions,
    int? commentsCount,
    String? category,
    int? fundNumber,
    bool? fromActiveCampaign,
  }) {
    return UsersProposalOverview(
      selfRef: selfRef ?? this.selfRef,
      parameters: parameters ?? this.parameters,
      title: title ?? this.title,
      updateDate: updateDate ?? this.updateDate,
      fundsRequested: fundsRequested ?? this.fundsRequested,
      publish: publish ?? this.publish,
      versions: versions ?? this.versions,
      commentsCount: commentsCount ?? this.commentsCount,
      category: category ?? this.category,
      fundNumber: fundNumber ?? this.fundNumber,
      fromActiveCampaign: fromActiveCampaign ?? this.fromActiveCampaign,
    );
  }
}
