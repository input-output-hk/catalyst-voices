import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

class BaseProposalData extends Equatable {
  final ProposalDocument document;
  final DocumentRef ref;
  final int commentsCount;

  const BaseProposalData({
    required this.document,
    required this.ref,
    this.commentsCount = 0,
  });

  @override
  List<Object?> get props => [
        document,
        ref,
        commentsCount,
      ];

  String? getProposalAuthor([ProposalDocument? doc]) {
    final property = (doc ?? document)
            .document
            .getProperty(ProposalDocument.authorNameNodeId)
        as DocumentValueProperty<String>?;

    return property?.value;
  }

  String? getProposalDescription([ProposalDocument? doc]) {
    final property = (doc ?? document)
            .document
            .getProperty(ProposalDocument.descriptionNodeId)
        as DocumentValueProperty<String>?;

    return property?.value;
  }

  int? getProposalDuration([ProposalDocument? doc]) {
    final property =
        (doc ?? document).document.getProperty(ProposalDocument.durationNodeId)
            as DocumentValueProperty<int>?;

    return property?.value;
  }

  Coin? getProposalFundsRequested([ProposalDocument? doc]) {
    final property = (doc ?? document)
            .document
            .getProperty(ProposalDocument.requestedFundsNodeId)
        as DocumentValueProperty<int>?;
    final value = property?.value;
    if (value == null) return null;
    return Coin(value);
  }

  String? getProposalTitle([ProposalDocument? doc]) {
    final property =
        (doc ?? document).document.getProperty(ProposalDocument.titleNodeId)
            as DocumentValueProperty<String>?;

    return property?.value;
  }

  ProposalVersion toProposalVersion() {
    return ProposalVersion(
      selfRef: ref,
      title: getProposalTitle() ?? '',
      createdAt: UuidUtils.dateTime(ref.version ?? ref.id),
      // TODO(LynxLynxx): from where we need to get the real status
      publish: ProposalPublish.publishedDraft,
    );
  }
}

class ProposalData extends BaseProposalData {
  final String categoryId;
  final List<BaseProposalData> versions;

  const ProposalData({
    required super.document,
    required super.ref,
    required this.categoryId,
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
