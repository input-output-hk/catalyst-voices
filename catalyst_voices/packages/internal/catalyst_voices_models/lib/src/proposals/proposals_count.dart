import 'package:catalyst_voices_models/catalyst_voices_models.dart' show ProposalsFilterType;
import 'package:equatable/equatable.dart';

final class ProposalsCount extends Equatable {
  final int total;
  final int drafts;
  final int finals;
  final int favorites;
  final int favoritesFinals;
  final int my;
  final int myFinals;
  final int voted;

  const ProposalsCount({
    this.total = 0,
    this.drafts = 0,
    this.finals = 0,
    this.favorites = 0,
    this.favoritesFinals = 0,
    this.my = 0,
    this.myFinals = 0,
    this.voted = 0,
  });

  @override
  List<Object?> get props => [
        total,
        drafts,
        finals,
        favorites,
        favoritesFinals,
        my,
        myFinals,
        voted,
      ];

  int ofType(ProposalsFilterType type) {
    return switch (type) {
      ProposalsFilterType.total => total,
      ProposalsFilterType.drafts => drafts,
      ProposalsFilterType.finals => finals,
      ProposalsFilterType.favorites => favorites,
      ProposalsFilterType.favoritesFinals => favoritesFinals,
      ProposalsFilterType.my => my,
      ProposalsFilterType.myFinals => myFinals,
      ProposalsFilterType.voted => voted,
    };
  }

  @override
  String toString() {
    return 'ProposalsCount('
        'total[$total], '
        'drafts[$drafts], '
        'finals[$finals], '
        'favorites[$favorites], '
        'favoritesFinals[$favoritesFinals], '
        'my[$my], '
        'myFinals[$myFinals], '
        'voted[$voted]'
        ')';
  }
}
