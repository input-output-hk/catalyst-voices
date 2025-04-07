import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid_plus/uuid_plus.dart';

class BaseProposalData extends Equatable {
  final ProposalDocument document;
  final ProposalPublish publish;

  const BaseProposalData({
    required this.document,
    required this.publish,
  });

  @override
  List<Object?> get props => [
        document,
        publish,
      ];

  ProposalVersion toProposalVersion() {
    return ProposalVersion(
      selfRef: document.metadata.selfRef,
      title: document.title ?? '',
      createdAt: UuidV7.parseDateTime(
        document.metadata.selfRef.version ?? document.metadata.selfRef.id,
      ),
      publish: publish,
    );
  }
}

class ProposalData extends BaseProposalData {
  final List<BaseProposalData> versions;
  final int commentsCount;
  final String categoryName;

  const ProposalData({
    required super.document,
    required super.publish,
    this.commentsCount = 0,
    this.categoryName = '',
    this.versions = const [],
  });

  SignedDocumentRef get categoryId => document.metadata.categoryId;

  List<ProposalVersion> get proposalVersions =>
      versions.map((v) => v.toProposalVersion()).toList();

  @override
  List<Object?> get props => [
        ...super.props,
        commentsCount,
        categoryName,
        versions,
      ];

  SignedDocumentRef get templateRef => document.metadata.templateRef;

  ProposalData copyWith({
    int? commentsCount,
    String? categoryName,
    List<BaseProposalData>? versions,
  }) {
    return ProposalData(
      document: document,
      publish: publish,
      commentsCount: commentsCount ?? this.commentsCount,
      categoryName: categoryName ?? this.categoryName,
      versions: versions ?? this.versions,
    );
  }
}
