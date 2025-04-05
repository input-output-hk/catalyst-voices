import 'package:equatable/equatable.dart';

final class ProposalsTypeCount extends Equatable {
  final int total;
  final int drafts;
  final int finals;
  final int favorites;
  final int my;

  const ProposalsTypeCount({
    this.total = 0,
    this.drafts = 0,
    this.finals = 0,
    this.favorites = 0,
    this.my = 0,
  });

  @override
  List<Object?> get props => [
        total,
        drafts,
        finals,
        favorites,
        my,
      ];

  ProposalsTypeCount copyWith({
    int? total,
    int? drafts,
    int? finals,
    int? favorites,
    int? my,
  }) {
    return ProposalsTypeCount(
      total: total ?? this.total,
      drafts: drafts ?? this.drafts,
      finals: finals ?? this.finals,
      my: my ?? this.my,
    );
  }
}
