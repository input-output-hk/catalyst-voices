import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid_plus/uuid_plus.dart';

class ProposalData extends Equatable {
  final ProposalDocument document;
  final ProposalPublish publish;
  final int commentsCount;

  const ProposalData({
    required this.document,
    required this.publish,
    this.commentsCount = 0,
  });

  @override
  List<Object?> get props => [
    document,
    publish,
    commentsCount,
  ];

  ProposalVersion toProposalVersion() {
    return ProposalVersion(
      id: document.metadata.id,
      title: document.title ?? '',
      createdAt: UuidV7.parseDateTime(
        document.metadata.id.ver ?? document.metadata.id.id,
      ),
      publish: publish,
    );
  }
}

class ProposalDetailData extends ProposalData {
  final List<ProposalVersion> versions;

  const ProposalDetailData({
    required super.document,
    required super.publish,
    required this.versions,
    required super.commentsCount,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    versions,
  ];
}
