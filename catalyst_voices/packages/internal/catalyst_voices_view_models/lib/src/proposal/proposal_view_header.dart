import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalViewHeader extends Equatable {
  final String? id;
  final String title;
  final String authorDisplayName;
  final DateTime? createdAt;
  final int commentsCount;
  final DocumentVersions versions;
  final bool isFavourite;

  const ProposalViewHeader({
    this.id,
    this.title = '',
    this.authorDisplayName = '',
    this.createdAt,
    this.commentsCount = 0,
    this.versions = const DocumentVersions(),
    this.isFavourite = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        authorDisplayName,
        createdAt,
        commentsCount,
        versions,
        isFavourite,
      ];

  ProposalViewHeader copyWith({
    Optional<String>? id,
    String? title,
    String? authorDisplayName,
    Optional<DateTime>? createdAt,
    int? commentsCount,
    DocumentVersions? versions,
    bool? isFavourite,
  }) {
    return ProposalViewHeader(
      id: id.dataOr(this.id),
      title: title ?? this.title,
      authorDisplayName: authorDisplayName ?? this.authorDisplayName,
      createdAt: createdAt.dataOr(this.createdAt),
      commentsCount: commentsCount ?? this.commentsCount,
      versions: versions ?? this.versions,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }
}
