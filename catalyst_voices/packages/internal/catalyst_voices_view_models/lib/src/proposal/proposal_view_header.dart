import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

/// View model representing proposal header in a view mode
final class ProposalViewHeader extends DocumentViewerHeader {
  final String? authorName;
  final int? commentsCount;

  const ProposalViewHeader({
    super.documentRef,
    super.title,
    this.authorName,
    super.createdAt,
    this.commentsCount,
    super.versions,
    super.isFavorite,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    authorName,
    commentsCount,
  ];

  @override
  ProposalViewHeader copyWith({
    Optional<DocumentRef>? documentRef,
    String? title,
    String? authorName,
    Optional<DateTime>? createdAt,
    Optional<int>? commentsCount,
    List<DocumentVersion>? versions,
    bool? isFavorite,
  }) {
    return ProposalViewHeader(
      documentRef: documentRef.dataOr(this.documentRef),
      title: title ?? this.title,
      authorName: authorName ?? this.authorName,
      createdAt: createdAt.dataOr(this.createdAt),
      commentsCount: commentsCount.dataOr(this.commentsCount),
      versions: versions ?? this.versions,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
