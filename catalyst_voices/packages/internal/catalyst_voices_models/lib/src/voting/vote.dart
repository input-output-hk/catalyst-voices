import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

/// Represents a vote on proposal.
final class Vote extends Equatable {
  final DocumentRef selfRef;

  /// Reference to proposal on which vote was casted.
  final DocumentRef proposal;

  /// Type of vote. See [VoteType].
  final VoteType type;

  Vote({
    required this.selfRef,
    required this.proposal,
    required this.type,
  }) : assert(selfRef.ver != null, 'selfRef have to be exact!');

  Vote.draft({
    String? id,
    required this.proposal,
    required this.type,
  }) : selfRef = id != null ? DraftRef.generateNextRefFor(id) : DraftRef.generateFirstRef();

  /// Extracts timestamp from [selfRef] version.
  DateTime get createdAt => selfRef.ver!.dateTime;

  /// Whether this vote is final and decision was already made.
  bool get isCasted => selfRef is SignedDocumentRef;

  @override
  List<Object?> get props => [
    selfRef,
    proposal,
    type,
  ];

  Vote copyWith({
    DocumentRef? selfRef,
    DocumentRef? proposal,
    VoteType? type,
  }) {
    return Vote(
      selfRef: selfRef ?? this.selfRef,
      proposal: proposal ?? this.proposal,
      type: type ?? this.type,
    );
  }

  /// Make a copy of [Vote] with signed [selfRef]. At this point it can not
  /// be modified.
  Vote toCasted() {
    assert(!isCasted, 'Vote is already casted!');

    return copyWith(selfRef: selfRef.toSignedDocumentRef());
  }
}

extension VoteListExt on List<Vote> {
  Vote? forProposal(DocumentRef proposal) =>
      firstWhereOrNull((element) => element.proposal == proposal);
}
