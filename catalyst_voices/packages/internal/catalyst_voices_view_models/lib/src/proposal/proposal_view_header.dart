import 'package:equatable/equatable.dart';

final class ProposalViewHeader extends Equatable {
  final String title;
  final String authorDisplayName;
  final DateTime? createdAt;
  final int commentsCount;
  final int iteration;
  final bool isFavourite;

  const ProposalViewHeader({
    this.title = '',
    this.authorDisplayName = '',
    this.createdAt,
    this.commentsCount = 0,
    this.iteration = 0,
    this.isFavourite = false,
  });

  @override
  List<Object?> get props => [
        title,
        authorDisplayName,
        createdAt,
        commentsCount,
        iteration,
        isFavourite,
      ];
}
