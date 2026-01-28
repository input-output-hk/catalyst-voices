import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

/// Representation of campaign timeline.
///
/// Defines timeline of different stages for [Campaign].
final class CampaignTimeline extends Equatable {
  final List<CampaignPhase> phases;

  const CampaignTimeline({
    required this.phases,
  });

  @override
  List<Object?> get props => [phases];

  /// Date range when results of voting are available.
  DateRange? get votingResultsDateRange {
    return phase(CampaignPhaseType.votingResults)?.timeline;
  }

  /// A date at which all decision prior to voting have to be made.
  /// For example, top up connected stake_address, delegate voting power,
  /// setup representative profile.
  ///
  /// Exact logic for how we're defining voting snapshot to be decided.
  ///
  /// At the moment we're looking for community voting phase start - 2 days.
  DateTime? get votingSnapshotDate {
    final votingPhase = phase(CampaignPhaseType.communityVoting);
    return votingPhase?.timeline.from?.subtract(const Duration(days: 2));
  }

  /// Date range when final votes count takes place.
  DateRange? get votingTallyDateRange {
    return phase(CampaignPhaseType.votingTally)?.timeline;
  }

  /// Finds specific [CampaignPhase] with matching [type].
  ///
  /// Syntax sugar method for working with [phases] list.
  CampaignPhase? phase(CampaignPhaseType type) {
    return phases.firstWhereOrNull((phase) => phase.type == type);
  }
}
