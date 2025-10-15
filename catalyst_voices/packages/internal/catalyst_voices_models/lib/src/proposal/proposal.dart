import 'package:catalyst_voices_models/catalyst_voices_models.dart';

final class Proposal extends CoreProposal {
  final int versionNumber;

  factory Proposal({
    required DocumentRef selfRef,
    required String title,
    required String description,
    required Money fundsRequested,
    required ProposalPublish publish,
    List<String> versionsIds = const [],
    required int duration,
    required String? author,
    required int commentsCount,
    required SignedDocumentRef categoryId,
  }) {
    final versionNumber = versionsIds.versionNumber(selfRef.version!);

    return Proposal._(
      selfRef: selfRef,
      title: title,
      fundsRequested: fundsRequested,
      publish: publish,
      commentsCount: commentsCount,
      description: description,
      duration: duration,
      author: author,
      versionNumber: versionNumber,
      categoryId: categoryId,
    );
  }

  factory Proposal.fromData(
    ProposalData data,
    SignedDocumentRef categoryId,
    List<String> versionsIds,
  ) {
    final document = data.document;

    return Proposal(
      selfRef: document.metadata.selfRef,
      title: document.title ?? '',
      description: document.description ?? '',
      fundsRequested: document.fundsRequested ?? Money.zero(currency: Currencies.fallback),
      publish: data.publish,
      duration: document.duration ?? 0,
      author: document.authorName,
      commentsCount: data.commentsCount,
      categoryId: categoryId,
      versionsIds: versionsIds,
    );
  }

  const Proposal._({
    required super.selfRef,
    required super.categoryId,
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
