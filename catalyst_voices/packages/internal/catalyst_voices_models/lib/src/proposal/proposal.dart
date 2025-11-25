import 'package:catalyst_voices_models/catalyst_voices_models.dart';

final class Proposal extends CoreProposal {
  final int versionNumber;

  factory Proposal({
    required DocumentRef id,
    required String title,
    required String description,
    required Money fundsRequested,
    required ProposalPublish publish,
    List<String> versionsIds = const [],
    required int duration,
    required String? author,
    required int commentsCount,
    required SignedDocumentRef categoryRef,
  }) {
    final versionNumber = versionsIds.versionNumber(id.ver!);

    return Proposal._(
      id: id,
      title: title,
      fundsRequested: fundsRequested,
      publish: publish,
      commentsCount: commentsCount,
      description: description,
      duration: duration,
      author: author,
      versionNumber: versionNumber,
      categoryRef: categoryRef,
    );
  }

  factory Proposal.fromData(ProposalData data, List<String> versionsIds) {
    final document = data.document;

    return Proposal(
      id: document.metadata.id,
      title: document.title ?? '',
      description: document.description ?? '',
      fundsRequested: document.fundsRequested ?? Money.zero(currency: Currencies.fallback),
      publish: data.publish,
      duration: document.duration ?? 0,
      author: document.authorName,
      commentsCount: data.commentsCount,
      categoryRef: data.document.metadata.categoryId,
      versionsIds: versionsIds,
    );
  }

  const Proposal._({
    required super.id,
    required super.categoryRef,
    required super.title,
    required super.description,
    required super.fundsRequested,
    required super.publish,
    required super.duration,
    required super.author,
    required super.commentsCount,
    required this.versionNumber,
  });
}

extension ProposalVersionsNumber on List<String> {
  int versionNumber(String version) {
    sort((versionA, versionB) => versionB.compareTo(versionA));
    return length - indexWhere((element) => element == version);
  }
}
