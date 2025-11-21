import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';

final class Proposal extends CoreProposal {
  final int versionNumber;

  factory Proposal({
    required DocumentRef selfRef,
    required DocumentParameters parameters,
    required String title,
    required String description,
    required Money fundsRequested,
    required ProposalPublish publish,
    List<String> versionsIds = const [],
    required int duration,
    required String? author,
    required int commentsCount,
  }) {
    final versionNumber = versionsIds.versionNumber(selfRef.version!);

    return Proposal._(
      selfRef: selfRef,
      parameters: parameters,
      title: title,
      fundsRequested: fundsRequested,
      publish: publish,
      commentsCount: commentsCount,
      description: description,
      duration: duration,
      author: author,
      versionNumber: versionNumber,
    );
  }

  factory Proposal.fromData(ProposalData data, List<String> versionsIds) {
    final document = data.document;

    return Proposal(
      selfRef: document.metadata.selfRef,
      parameters: document.metadata.parameters,
      title: document.title ?? '',
      description: document.description ?? '',
      fundsRequested: document.fundsRequested ?? Money.zero(currency: Currencies.fallback),
      publish: data.publish,
      duration: document.duration ?? 0,
      author: document.authorName,
      commentsCount: data.commentsCount,
      versionsIds: versionsIds,
    );
  }

  const Proposal._({
    required super.selfRef,
    required super.parameters,
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
    final list = sorted((versionA, versionB) => versionB.compareTo(versionA));
    return list.length - list.indexWhere((element) => element == version);
  }
}
