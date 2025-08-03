import 'package:catalyst_voices_models/catalyst_voices_models.dart' show ProposalsFilterType;
import 'package:equatable/equatable.dart';

final class ProposalsCount extends Equatable {
  final int total;
  final int drafts;
  final int finals;
  final int favorites;
  final int my;
  final int voted;

  const ProposalsCount({
    this.total = 0,
    this.drafts = 0,
    this.finals = 0,
    this.favorites = 0,
    this.my = 0,
    this.voted = 0,
  });

  @override
  List<Object?> get props => [
        total,
        drafts,
        finals,
        favorites,
        my,
        voted,
      ];

  int ofType(ProposalsFilterType type) {
    return switch (type) {
      ProposalsFilterType.total => total,
      ProposalsFilterType.drafts => drafts,
      ProposalsFilterType.finals => finals,
      ProposalsFilterType.favorites => favorites,
      ProposalsFilterType.my => my,
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
        'my[$my], '
        'voted[$voted]'
        ')';
  }
}
