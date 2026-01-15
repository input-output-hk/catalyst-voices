import 'package:catalyst_voices_models/catalyst_voices_models.dart';

final class DetailProposal extends CoreProposal {
  final List<ProposalVersion> versions;

  factory DetailProposal({
    required DocumentRef id,
    required DocumentParameters parameters,
    required String title,
    required String description,
    required Money fundsRequested,
    required ProposalPublish publish,
    required int duration,
    required String? author,
    required int commentsCount,
    required List<ProposalVersion> versions,
  }) {
    versions.sort();

    return DetailProposal._(
      id: id,
      parameters: parameters,
      title: title,
      description: description,
      fundsRequested: fundsRequested,
      publish: publish,
      duration: duration,
      author: author,
      commentsCount: commentsCount,
      versions: versions,
    );
  }

  factory DetailProposal.fromData(
    ProposalData data,
    List<ProposalVersion> versions,
  ) {
    return DetailProposal(
      id: data.document.metadata.id,
      parameters: data.document.metadata.parameters,
      title: data.document.title ?? '',
      description: data.document.description ?? '',
      fundsRequested: data.document.fundsRequested ?? Money.zero(currency: Currencies.fallback),
      publish: data.publish,
      duration: data.document.duration ?? 0,
      author: data.document.authorName,
      commentsCount: data.commentsCount,
      versions: versions,
    );
  }

  const DetailProposal._({
    required super.id,
    required super.parameters,
    required super.title,
    required super.description,
    required super.fundsRequested,
    required super.publish,
    required super.duration,
    required super.author,
    required super.commentsCount,
    required this.versions,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    versions,
  ];

  int get versionNumber => versions.versionNumber(id.ver!);
}

extension ProposalWithVersionX on DetailProposal {
  static DetailProposal dummy(ProposalPublish publish, {SignedDocumentRef? categoryRef}) =>
      DetailProposal(
        id: const SignedDocumentRef(
          id: '019584be-f0ef-7b01-8d36-422a3d6a0533',
          ver: '019584be-2321-7a1a-9b68-ad33a97a7e84',
        ),
        parameters: DocumentParameters({categoryRef ?? SignedDocumentRef.generateFirstRef()}),
        title: 'Dummy Proposal ver 2',
        description: 'Dummy description',
        fundsRequested: Money(currency: Currencies.ada, minorUnits: BigInt.from(100)),
        publish: publish,
        duration: 6,
        author: 'Alex Wells',
        commentsCount: 0,
        versions: [
          ProposalVersion(
            publish: ProposalPublish.publishedDraft,
            id: const SignedDocumentRef(
              id: '019584be-f0ef-7b01-8d36-422a3d6a0533',
              ver: '019584be-2314-7aaa-8b21-0f902ff817d4',
            ),
            title: 'Title ver 1',
            createdAt: DateTime.now(),
          ),
          ProposalVersion(
            publish: ProposalPublish.submittedProposal,
            id: const SignedDocumentRef(
              id: '019584be-f0ef-7b01-8d36-422a3d6a0533',
              ver: '019584be-2321-7a1a-9b68-ad33a97a7e84',
            ),
            title: 'Dummy Proposal ver 2',
            createdAt: DateTime.now(),
          ),
          ProposalVersion(
            publish: ProposalPublish.publishedDraft,
            id: const SignedDocumentRef(
              id: '019584be-f0ef-7b01-8d36-422a3d6a0533',
              ver: '019584be-232d-729b-950d-ce9fb79513ed',
            ),
            title: 'Title ver 3',
            createdAt: DateTime.now(),
          ),
        ],
      );
}
