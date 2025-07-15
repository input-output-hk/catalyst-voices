import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

/// Represents a vote on proposal.
final class Vote extends Equatable {
  final DocumentRef selfRef;

  /// Reference to proposal on which vote was casted.
  final DocumentRef ref;

  /// Type of vote. See [VoteType].
  final VoteType type;

  Vote({
    required this.selfRef,
    required this.ref,
    required this.type,
  }) : assert(selfRef.version != null, 'selfRef have to be exact!');

  Vote.draft({
    required this.ref,
    required this.type,
  }) : selfRef = DraftRef.generateFirstRef();

  /// Extracts timestamp from [selfRef] version.
  DateTime get createdAt => selfRef.version!.dateTime;

  /// Whether this vote is final and decision was already made.
  bool get isCasted => selfRef is SignedDocumentRef;

  @override
  List<Object?> get props => [
        selfRef,
        ref,
        type,
      ];

  Vote copyWith({
    DocumentRef? selfRef,
    DocumentRef? ref,
    VoteType? type,
  }) {
    return Vote(
      selfRef: selfRef ?? this.selfRef,
      ref: ref ?? this.ref,
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
