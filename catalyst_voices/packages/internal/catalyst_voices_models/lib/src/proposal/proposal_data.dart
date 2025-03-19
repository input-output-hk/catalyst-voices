import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid_plus/uuid_plus.dart';

class BaseProposalData extends Equatable {
  final ProposalDocument document;

  const BaseProposalData({
    required this.document,
  });

  @override
  List<Object?> get props => [
        document,
      ];

  ProposalVersion toProposalVersion() {
    return ProposalVersion(
      selfRef: document.metadata.selfRef,
      title: getProposalTitle(document) ?? '',
      createdAt: UuidV7.parseDateTime(
        document.metadata.selfRef.version ?? document.metadata.selfRef.id,
      ),
      // TODO(LynxLynxx): from where we need to get the real status
      publish: ProposalPublish.publishedDraft,
    );
  }

  static String? getProposalAuthor(ProposalDocument document) {
    final property = document.document.getProperty(
      ProposalDocument.authorNameNodeId,
    ) as DocumentValueProperty<String>?;

    return property?.value;
  }

  static String? getProposalDescription(ProposalDocument document) {
    final property =
        document.document.getProperty(ProposalDocument.descriptionNodeId)
            as DocumentValueProperty<String>?;

    return property?.value;
  }

  static int? getProposalDuration(ProposalDocument document) {
    final property =
        document.document.getProperty(ProposalDocument.durationNodeId)
            as DocumentValueProperty<int>?;

    return property?.value;
  }

  static Coin? getProposalFundsRequested(ProposalDocument document) {
    final property =
        document.document.getProperty(ProposalDocument.requestedFundsNodeId)
            as DocumentValueProperty<int>?;
    final value = property?.value;
    if (value == null) return null;
    return Coin(value);
  }

  static String? getProposalTitle(ProposalDocument document) {
    final property = document.document.getProperty(ProposalDocument.titleNodeId)
        as DocumentValueProperty<String>?;

    return property?.value;
  }
}

class ProposalData extends BaseProposalData {
  final List<BaseProposalData> versions;
  final int commentsCount;
  final String categoryName;

  const ProposalData({
    required super.document,
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
}
