import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class Proposal extends Equatable {
  final String id;
  final String version;
  final String title;
  final String description;
  final DateTime updateDate;
  final DateTime? fundedDate;
  final Coin fundsRequested;
  final ProposalStatus status;
  final ProposalPublish publish;
  final int versionCount;
  final int duration;
  final String author;
  final int commentsCount;
  final String category;

  const Proposal({
    required this.id,
    required this.version,
    required this.title,
    required this.description,
    required this.updateDate,
    this.fundedDate,
    required this.fundsRequested,
    required this.status,
    required this.publish,
    required this.versionCount,
    required this.duration,
    required this.author,
    required this.commentsCount,
    required this.category,
  });

  factory Proposal.fromData(ProposalData data) {
    final updateDate = UuidV7.parseTimestamp(data.document.metadata.version);
    return Proposal(
      id: data.document.metadata.id,
      version: data.document.metadata.version,
      title: data.proposalTitle,
      description: data.proposalDescription,
      updateDate: updateDate,
      fundsRequested: data.proposalFundsRequested,
      // TODO(LynxLynxx): from here we need to get the real status
      status: ProposalStatus.inProgress,
      // TODO(LynxLynxx): from here we need to get the real publish
      publish: ProposalPublish.publishedDraft,
      versionCount: data.versions.length,
      duration: data.proposalDuration,
      author: data.proposalAuthor,
      commentsCount: data.commentsCount,
      category: data.categoryId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        updateDate,
        fundedDate,
        fundsRequested,
        status,
        publish,
        category,
        commentsCount,
      ];

  ProposalMetadata get ref => ProposalMetadata(id: id, version: version);
}
