import 'package:equatable/equatable.dart';

final class ProposalsCount extends Equatable {
  final int total;
  final int drafts;
  final int finals;
  final int favorites;
  final int my;

  const ProposalsCount({
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
}
