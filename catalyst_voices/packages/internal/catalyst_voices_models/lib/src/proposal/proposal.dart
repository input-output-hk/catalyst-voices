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
  final List<ProposalVersion> versions;
  final int duration;
  final String author;
  final int commentsCount;
  final String category;
  final SignedDocumentRef categoryId;

  factory Proposal({
    required DocumentRef selfRef,
    required String title,
    required String description,
    required DateTime updateDate,
    DateTime? fundedDate,
    required Coin fundsRequested,
    required ProposalStatus status,
    required ProposalPublish publish,
    List<ProposalVersion> versions = const [],
    required int duration,
    required String author,
    required int commentsCount,
    required String category,
    required SignedDocumentRef categoryId,
  }) {
    final sortedVersions = List<ProposalVersion>.from(versions)..sort();

    return Proposal._(
      selfRef: selfRef,
      category: category,
      title: title,
      updateDate: updateDate,
      fundedDate: fundedDate,
      fundsRequested: fundsRequested,
      status: status,
      publish: publish,
      commentsCount: commentsCount,
      description: description,
      duration: duration,
      author: author,
      versions: sortedVersions,
      categoryId: categoryId,
    );
  }

  factory Proposal.fromData(ProposalData data) {
    final document = data.document;
    final updateDate = document.metadata.selfRef.version!.dateTime;

    final versions = data.versions.map(ProposalVersion.fromData).toList()
      ..sort();

    return Proposal._(
      selfRef: document.metadata.selfRef,
      title: document.title ?? '',
      description: document.description ?? '',
      updateDate: updateDate,
      fundsRequested: document.fundsRequested ?? const Coin.fromWholeAda(0),
      status: ProposalStatus.inProgress,
      publish: data.publish,
      duration: document.duration ?? 0,
      author: document.authorName ?? '',
      commentsCount: data.commentsCount,
      categoryId: data.categoryId,
      category: data.categoryName,
      versions: versions,
    );
  }

  const Proposal._({
    required this.selfRef,
    required this.title,
    required this.description,
    required this.updateDate,
    this.fundedDate,
    required this.fundsRequested,
    required this.status,
    required this.publish,
    this.versions = const [],
    required this.duration,
    required this.author,
    required this.commentsCount,
    required this.category,
    required this.categoryId,
  });

  bool get hasNewerLocalIteration {
    if (versions.isEmpty) return false;
    final latestVersion = versions.first;
    return latestVersion.isLatestVersion(
      selfRef.version ?? '',
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
        categoryId,
        commentsCount,
        versionCount,
        versions,
      ];

  int get versionCount => versions.isEmpty ? 1 : versions.length;

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
    List<ProposalVersion>? versions,
    String? category,
    SignedDocumentRef? categoryId,
  }) =>
      Proposal._(
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
        versions: versions ?? this.versions,
        category: category ?? this.category,
        categoryId: categoryId ?? this.categoryId,
      );
}

extension ProposalWithVersionX on Proposal {
  static Proposal dummy(ProposalPublish publish) => Proposal._(
        selfRef: const SignedDocumentRef(
          id: '019584be-f0ef-7b01-8d36-422a3d6a0533',
          version: '019584be-2321-7a1a-9b68-ad33a97a7e84',
        ),
        categoryId: SignedDocumentRef.generateFirstRef(),
        title: 'Dummy Proposal ver 2',
        description: 'Dummy description',
        updateDate: DateTime.now(),
        fundsRequested: const Coin(100),
        status: ProposalStatus.draft,
        publish: publish,
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
