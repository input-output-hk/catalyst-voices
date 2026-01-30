import 'package:catalyst_voices_view_models/src/voting/timeline/voting_timeline_footer_event.dart';
import 'package:equatable/equatable.dart';

/// View model for voting timeline footer widget.
final class VotingTimelineFooterViewModel extends Equatable {
  final VotingTimelineFooterEvent? leftEvent;
  final VotingTimelineFooterEvent? rightEvent;

  const VotingTimelineFooterViewModel({
    this.leftEvent,
    this.rightEvent,
  });

  @override
  List<Object?> get props => [leftEvent, rightEvent];
}
