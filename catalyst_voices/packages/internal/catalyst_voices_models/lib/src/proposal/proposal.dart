import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final class Proposal extends Equatable {
  final DocumentRef selfRef;
  final String title;
  final String description;
  final DateTime updateDate;
  final DateTime? fundedDate;
  final Coin fundsRequested;
  final ProposalStatus status;
  final ProposalPublish publish;
  final int versionCount;
  final int duration;
  final String author;
  final int commentsCount;
  final String category;

  const Proposal({
    required this.selfRef,
    required this.title,
    required this.description,
    required this.updateDate,
    this.fundedDate,
    required this.fundsRequested,
    required this.status,
    required this.publish,
    required this.versionCount,
    required this.duration,
    required this.author,
    required this.commentsCount,
    required this.category,
  });

  factory Proposal.dummy(DocumentRef ref) => Proposal(
        selfRef: ref,
        category: 'Cardano Use Cases / MVP',
        title: 'Dummy Proposal',
        updateDate: DateTime.now(),
        fundsRequested: Coin.fromAda(100000),
        status: ProposalStatus.draft,
        publish: ProposalPublish.localDraft,
        commentsCount: 0,
        description: 'Dummy description',
        duration: 6,
        author: 'Alex Wells',
        versionCount: 1,
      );

  factory Proposal.fromData(ProposalData data) {
    DateTime updateDate;
    final version = data.document.metadata.selfRef.version ??
        data.document.metadata.selfRef.id;
    updateDate = UuidUtils.dateTime(version);

    return Proposal(
      selfRef: data.document.metadata.selfRef,
      title: data.getProposalTitle() ?? '',
      description: data.getProposalDescription() ?? '',
      updateDate: updateDate,
      fundsRequested: data.getProposalFundsRequested() ?? Coin.fromAda(0),
      // TODO(LynxLynxx): from where we need to get the real status
      status: ProposalStatus.inProgress,
      // TODO(LynxLynxx): from where we need to get the real publish
      publish: ProposalPublish.publishedDraft,
      versionCount: data.versions.length,
      duration: data.getProposalDuration() ?? 0,
      author: data.getProposalAuthor() ?? '',
      commentsCount: data.commentsCount,
      category: data.categoryId,
    );
  }

  @override
  List<Object?> get props => [
        selfRef,
        title,
        description,
        updateDate,
        fundedDate,
        fundsRequested,
        status,
        publish,
        category,
        commentsCount,
      ];

  Proposal copyWith({
    DocumentRef? selfRef,
    String? title,
    String? description,
    DateTime? updateDate,
    Coin? fundsRequested,
    ProposalStatus? status,
    ProposalPublish? publish,
    int? commentsCount,
    int? duration,
    String? author,
    int? versionCount,
    String? category,
  }) =>
      Proposal(
        selfRef: selfRef ?? this.selfRef,
        title: title ?? this.title,
        description: description ?? this.description,
        updateDate: updateDate ?? this.updateDate,
        fundsRequested: fundsRequested ?? this.fundsRequested,
        status: status ?? this.status,
        publish: publish ?? this.publish,
        commentsCount: commentsCount ?? this.commentsCount,
        duration: duration ?? this.duration,
        author: author ?? this.author,
        versionCount: versionCount ?? this.versionCount,
        category: category ?? this.category,
      );
}

final class ProposalWithVersions extends Proposal {
  final List<ProposalVersion> versions;

  factory ProposalWithVersions({
    required DocumentRef selfRef,
    required String title,
    required String description,
    required DateTime updateDate,
    DateTime? fundedDate,
    required Coin fundsRequested,
    required ProposalStatus status,
    required ProposalPublish publish,
    required int versionCount,
    required int duration,
    required String author,
    required int commentsCount,
    required String category,
    required List<ProposalVersion> versions,
  }) {
    final sortedVersions = List<ProposalVersion>.from(versions)..sort();

    return ProposalWithVersions._(
      selfRef: selfRef,
      title: title,
      description: description,
      updateDate: updateDate,
      fundedDate: fundedDate,
      fundsRequested: fundsRequested,
      status: status,
      publish: publish,
      versionCount: versionCount,
      duration: duration,
      author: author,
      commentsCount: commentsCount,
      category: category,
      versions: sortedVersions,
    );
  }

  const ProposalWithVersions._({
    required super.selfRef,
    required super.title,
    required super.description,
    required super.updateDate,
    super.fundedDate,
    required super.fundsRequested,
    required super.status,
    required super.publish,
    required super.versionCount,
    required super.duration,
    required super.author,
    required super.commentsCount,
    required super.category,
    required this.versions,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        versions,
      ];

  @override
  ProposalWithVersions copyWith({
    DocumentRef? selfRef,
    String? title,
    String? description,
    DateTime? updateDate,
    Coin? fundsRequested,
    ProposalStatus? status,
    ProposalPublish? publish,
    int? commentsCount,
    int? duration,
    String? author,
    int? versionCount,
    String? category,
    List<ProposalVersion>? versions,
  }) =>
      ProposalWithVersions(
        selfRef: selfRef ?? this.selfRef,
        title: title ?? this.title,
        description: description ?? this.description,
        updateDate: updateDate ?? this.updateDate,
        fundsRequested: fundsRequested ?? this.fundsRequested,
        status: status ?? this.status,
        publish: publish ?? this.publish,
        commentsCount: commentsCount ?? this.commentsCount,
        duration: duration ?? this.duration,
        author: author ?? this.author,
        versionCount: versionCount ?? this.versionCount,
        category: category ?? this.category,
        versions: versions ?? this.versions,
      );
}

extension ProposalWithVersionX on ProposalWithVersions {
  static ProposalWithVersions dummy(ProposalPublish publish) =>
      ProposalWithVersions(
        selfRef: const SignedDocumentRef(
          id: '019584be-f0ef-7b01-8d36-422a3d6a0533',
          version: '019584be-2321-7a1a-9b68-ad33a97a7e84',
        ),
        title: 'Dummy Proposal ver 2',
        description: 'Dummy description',
        updateDate: DateTime.now(),
        fundsRequested: const Coin(100),
        status: ProposalStatus.draft,
        publish: publish,
        versionCount: 3,
        duration: 6,
        author: 'Alex Wells',
        commentsCount: 0,
        category: 'Cardano Use Cases / MVP',
        versions: [
          ProposalVersion(
            publish: ProposalPublish.publishedDraft,
            selfRef: const SignedDocumentRef(
              id: '019584be-f0ef-7b01-8d36-422a3d6a0533',
              version: '019584be-2314-7aaa-8b21-0f902ff817d4',
            ),
            title: 'Title ver 1',
            createdAt: DateTime.now(),
          ),
          ProposalVersion(
            publish: ProposalPublish.submittedProposal,
            selfRef: const SignedDocumentRef(
              id: '019584be-f0ef-7b01-8d36-422a3d6a0533',
              version: '019584be-2321-7a1a-9b68-ad33a97a7e84',
            ),
            title: 'Dummy Proposal ver 2',
            createdAt: DateTime.now(),
          ),
          ProposalVersion(
            publish: ProposalPublish.publishedDraft,
            selfRef: const SignedDocumentRef(
              id: '019584be-f0ef-7b01-8d36-422a3d6a0533',
              version: '019584be-232d-729b-950d-ce9fb79513ed',
            ),
            title: 'Title ver 3',
            createdAt: DateTime.now(),
          ),
        ],
      );
}
