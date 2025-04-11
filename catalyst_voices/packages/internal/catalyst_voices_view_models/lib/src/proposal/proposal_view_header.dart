import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalViewHeader extends Equatable {
  final DocumentRef? selfRef;
  final String title;
  final String authorName;
  final DateTime? createdAt;
  final int commentsCount;
  final List<DocumentVersion> versions;
  final bool isFavorite;

  const ProposalViewHeader({
    this.selfRef,
    this.title = '',
    this.authorName = '',
    this.createdAt,
    this.commentsCount = 0,
    this.versions = const <DocumentVersion>[],
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [
        selfRef,
        title,
        authorName,
        createdAt,
        commentsCount,
        versions,
        isFavorite,
      ];

  ProposalViewHeader copyWith({
    Optional<DocumentRef>? selfRef,
    String? title,
    String? authorName,
    Optional<DateTime>? createdAt,
    int? commentsCount,
    List<DocumentVersion>? versions,
    bool? isFavorite,
  }) {
    return ProposalViewHeader(
      selfRef: selfRef.dataOr(this.selfRef),
      title: title ?? this.title,
      authorName: authorName ?? this.authorName,
      createdAt: createdAt.dataOr(this.createdAt),
      commentsCount: commentsCount ?? this.commentsCount,
      versions: versions ?? this.versions,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
