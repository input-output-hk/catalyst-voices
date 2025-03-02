import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

// Note. Most, if not all, fields will be removed from here because they come
// from document.
base class ProposalBase extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime updateDate;
  final DateTime? fundedDate;
  final Coin fundsRequested;
  final ProposalStatus status;
  final ProposalPublish publish;

  // Most likely this will be inside the document class and not in this class
  final int version;
  final int duration;
  final String author;

  // This may be a reference to class
  final String category;

  // Those may be getters.
  final int commentsCount;

  const ProposalBase({
    required this.id,
    required this.title,
    required this.description,
    required this.updateDate,
    this.fundedDate,
    required this.fundsRequested,
    required this.status,
    required this.publish,
    required this.category,
    required this.commentsCount,
    required this.version,
    required this.duration,
    required this.author,
  });

  int get completedSegments => 0;

  @override
  @mustCallSuper
  List<Object?> get props => [
        id,
        title,
        description,
        updateDate,
        fundedDate,
        fundsRequested.value,
        status,
        publish,
        category,
        commentsCount,
      ];

  // TODO(damian-molinski): this should come from api
  DocumentRef get ref => const SignedDocumentRef(id: 'document');

  int get totalSegments => 0;

  Proposal toProposal({
    required ProposalDocument document,
  }) {
    return Proposal(
      id: id,
      title: title,
      description: description,
      updateDate: updateDate,
      fundsRequested: fundsRequested,
      status: status,
      publish: publish,
      category: category,
      commentsCount: commentsCount,
      document: document,
      version: version,
      duration: duration,
      author: author,
    );
  }
}

enum ProposalPublish {
  /// A proposal has not yet been published,
  /// it's stored only in the local storage.
  localDraft,

  /// A proposal has been published as a draft.
  publishedDraft,

  /// A proposal has been published and submitted into review.
  ///
  /// After the review stage is done the proposal will be live
  /// with no additional proposer action.
  submittedProposal;

  bool get isDraft => this == publishedDraft;

  bool get isPublished => this == submittedProposal;
}

// Note. This enum may be deleted later. Its here for backwards compatibility.
enum ProposalStatus { ready, draft, inProgress, private, open, live, completed }
