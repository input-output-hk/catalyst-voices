import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid_plus/uuid_plus.dart';

final class Proposal extends Equatable {
  final DocumentRef selfRef;
  final String title;
  final String description;
  final DateTime? updateDate;
  final DateTime? fundedDate;
  final Coin fundsRequested;
  final ProposalStatus status;
  final ProposalPublish publish;
  final int versionCount;
  final int duration;
  final String author;
  final int commentsCount;
  final String category;
  final SignedDocumentRef categoryId;

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
    required this.categoryId,
  });

  factory Proposal.dummy(DocumentRef ref) => Proposal(
        selfRef: ref,
        category: 'Cardano Use Cases / MVP',
        categoryId: const SignedDocumentRef(id: 'dummy_category_id'),
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
    DateTime? updateDate;
    final version = data.document.metadata.selfRef.version;
    if (version != null) {
      updateDate = UuidV7.parseDateTime(version, utc: true);
    }
    return Proposal(
      selfRef: data.document.metadata.selfRef,
      title: data.proposalTitle ?? '',
      description: data.proposalDescription ?? '',
      updateDate: updateDate,
      fundsRequested: data.proposalFundsRequested ?? Coin.fromAda(0),
      // TODO(LynxLynxx): from here we need to get the real status
      status: ProposalStatus.inProgress,
      // TODO(LynxLynxx): from here we need to get the real publish
      publish: ProposalPublish.publishedDraft,
      versionCount: data.versions.length,
      duration: data.proposalDuration ?? 0,
      author: data.proposalAuthor ?? '',
      commentsCount: data.commentsCount,
      category: data.categoryId.id,
      categoryId: data.categoryId,
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
    SignedDocumentRef? categoryId,
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
        categoryId: categoryId ?? this.categoryId,
      );
}
