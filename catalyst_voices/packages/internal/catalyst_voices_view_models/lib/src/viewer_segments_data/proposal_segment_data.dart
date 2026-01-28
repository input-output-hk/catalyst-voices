import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Data for building proposal segments containing app-level state and permissions.
final class ProposalSegmentData extends Equatable {
  /// The active account ID of the current user.
  final CatalystId? activeAccountId;

  /// Whether the active account has a username set.
  final bool hasAccountUsername;

  /// Whether the app is currently in voting stage.
  final bool isVotingStage;

  /// Whether comments should be displayed.
  final bool showComments;

  const ProposalSegmentData({
    required this.activeAccountId,
    required this.hasAccountUsername,
    required this.isVotingStage,
    required this.showComments,
  });

  bool get hasActiveAccount => activeAccountId != null;

  @override
  List<Object?> get props => [
    activeAccountId,
    hasAccountUsername,
    isVotingStage,
    showComments,
  ];
}
