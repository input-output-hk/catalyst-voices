import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';

final class Proposal extends CoreProposal {
  final int versionNumber;

  factory Proposal({
    required DocumentRef id,
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
    final versionNumber = versionsIds.versionNumber(id.ver!);

    return Proposal._(
      id: id,
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
      id: document.metadata.id,
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

  factory Proposal.fromDetailData(ProposalDetailData data) {
    final versionsIds = data.versions.map((e) => e.id.ver).whereType<String>().toList();
    return Proposal.fromData(data, versionsIds);
  }

  const Proposal._({
    required super.id,
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
