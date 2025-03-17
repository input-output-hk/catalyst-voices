import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

class BaseProposalData extends Equatable {
  final ProposalDocument document;
  final SignedDocumentRef categoryId;
  final int commentsCount;

  const BaseProposalData({
    required this.document,
    required this.categoryId,
    this.commentsCount = 0,
  });

  @override
  List<Object?> get props => [
        document,
        commentsCount,
      ];

  ProposalVersion toProposalVersion() {
    return ProposalVersion(
      selfRef: document.metadata.selfRef,
      title: getProposalTitle(document) ?? '',
      createdAt: UuidUtils.dateTime(
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

  const ProposalData({
    required super.document,
    required super.categoryId,
    super.commentsCount = 0,
    this.versions = const [],
  });

  List<ProposalVersion> get proposalVersions =>
      versions.map((v) => v.toProposalVersion()).toList();

  @override
  List<Object?> get props => [
        ...super.props,
        categoryId,
        versions,
      ];
}
