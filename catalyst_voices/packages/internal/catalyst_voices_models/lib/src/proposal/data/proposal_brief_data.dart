import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalBriefData extends Equatable {
  final DocumentRef selfRef;
  final String authorName;
  final String title;
  final String description;
  final String categoryName;
  final int durationInMonths;
  final Money fundsRequested;
  final DateTime createdAt;
  final int iteration;
  final int commentsCount;
  final bool isFinal;
  final bool isFavorite;

  const ProposalBriefData({
    required this.selfRef,
    required this.authorName,
    required this.title,
    required this.description,
    required this.categoryName,
    required this.durationInMonths,
    required this.fundsRequested,
    required this.createdAt,
    required this.iteration,
    required this.commentsCount,
    required this.isFinal,
    required this.isFavorite,
  });

  @override
  List<Object?> get props => [
    selfRef,
    authorName,
    title,
    description,
    categoryName,
    durationInMonths,
    fundsRequested,
    createdAt,
    iteration,
    commentsCount,
    isFinal,
    isFavorite,
  ];
}
