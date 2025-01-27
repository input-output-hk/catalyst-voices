import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

// Note. This enum may be deleted later. Its here for backwards compatibility.
enum ProposalStatus { ready, draft, inProgress, private, open, live, completed }

enum ProposalPublish {
  draft,
  published;

  bool get isDraft => this == draft;
}

enum ProposalAccess { private, public }

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
  final ProposalAccess access;
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
    required this.access,
    required this.category,
    required this.commentsCount,
    required this.version,
    required this.duration,
    required this.author,
  });

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
      access: access,
      category: category,
      commentsCount: commentsCount,
      document: document,
      version: version,
      duration: duration,
      author: author,
    );
  }

  int get totalSegments => 0;

  int get completedSegments => 0;

  // TODO(damian-molinski): this should come from api
  SignedDocumentRef get ref => const SignedDocumentRef(id: 'document');

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
        access,
        category,
        commentsCount,
      ];
}
