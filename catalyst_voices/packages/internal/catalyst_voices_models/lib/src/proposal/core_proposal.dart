import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

base class CoreProposal extends Equatable implements Comparable<CoreProposal> {
  final DocumentRef selfRef;
  final SignedDocumentRef categoryId;
  final String title;
  final String description;
  final Money fundsRequested;
  final ProposalPublish publish;
  final int duration;
  final String? author;
  final int commentsCount;

  const CoreProposal({
    required this.selfRef,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.fundsRequested,
    required this.publish,
    required this.duration,
    required this.author,
    required this.commentsCount,
  });

  @override
  List<Object?> get props => [
    selfRef,
    categoryId,
    title,
    description,
    fundsRequested,
    publish,
    duration,
    author,
    commentsCount,
  ];

  DateTime get updateDate => selfRef.version!.dateTime;

  @override
  int compareTo(CoreProposal other) {
    if (publish != other.publish) {
      // sort by status first
      return publish.compareTo(other.publish);
    }

    // most recent first, older later
    return other.updateDate.compareTo(updateDate);
  }

  CoreProposal copyWith({
    DocumentRef? selfRef,
    SignedDocumentRef? categoryId,
    String? title,
    String? description,
    DateTime? updateDate,
    Money? fundsRequested,
    ProposalPublish? publish,
    int? duration,
    String? author,
    int? commentsCount,
  }) {
    return CoreProposal(
      selfRef: selfRef ?? this.selfRef,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      fundsRequested: fundsRequested ?? this.fundsRequested,
      publish: publish ?? this.publish,
      duration: duration ?? this.duration,
      author: author ?? this.author,
      commentsCount: commentsCount ?? this.commentsCount,
    );
  }
}
