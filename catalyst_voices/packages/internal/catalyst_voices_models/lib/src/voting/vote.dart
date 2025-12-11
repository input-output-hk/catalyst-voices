import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

/// Represents a vote on proposal.
final class Vote extends Equatable {
  final DocumentRef id;

  /// Reference to proposal on which vote was casted.
  final DocumentRef proposal;

  /// Type of vote. See [VoteType].
  final VoteType type;

  Vote({
    required this.id,
    required this.proposal,
    required this.type,
  }) : assert(id.ver != null, 'id have to be exact!');

  Vote.draft({
    String? id,
    required this.proposal,
    required this.type,
  }) : id = id != null ? DraftRef.generateNextRefFor(id) : DraftRef.generateFirstRef();

  /// Extracts timestamp from [id] version.
  DateTime get createdAt => id.ver!.dateTime;

  /// Whether this vote is final and decision was already made.
  bool get isCasted => id is SignedDocumentRef;

  @override
  List<Object?> get props => [
    id,
    proposal,
    type,
  ];

  Vote copyWith({
    DocumentRef? id,
    DocumentRef? proposal,
    VoteType? type,
  }) {
    return Vote(
      id: id ?? this.id,
      proposal: proposal ?? this.proposal,
      type: type ?? this.type,
    );
  }

  /// Make a copy of [Vote] with signed [id]. At this point it can not
  /// be modified.
  Vote toCasted() {
    assert(!isCasted, 'Vote is already casted!');

    return copyWith(id: id.toSignedDocumentRef());
  }
}

extension VoteListExt on List<Vote> {
  Vote? forProposal(DocumentRef proposal) =>
      firstWhereOrNull((element) => element.proposal == proposal);
}
