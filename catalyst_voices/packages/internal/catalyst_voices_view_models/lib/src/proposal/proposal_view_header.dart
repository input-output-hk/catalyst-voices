import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalViewHeader extends Equatable {
  final String title;
  final String authorDisplayName;
  final DateTime? createdAt;
  final int commentsCount;
  final DocumentVersions versions;
  final bool isFavourite;

  const ProposalViewHeader({
    this.title = '',
    this.authorDisplayName = '',
    this.createdAt,
    this.commentsCount = 0,
    this.versions = const DocumentVersions(),
    this.isFavourite = false,
  });

  @override
  List<Object?> get props => [
        title,
        authorDisplayName,
        createdAt,
        commentsCount,
        versions,
        isFavourite,
      ];
}
