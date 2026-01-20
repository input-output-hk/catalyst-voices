import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Detailed profile information for a representative.
final class RepresentativeDetails extends Equatable {
  /// The raw document data.
  final DocumentData doc;

  /// The template document data, if available.
  final DocumentData? template;

  /// List of known versions of [doc].
  final List<DocumentRef>? versions;

  /// In context of local active user (not account).
  final bool isFavorite;

  /// The number of delegates supporting this representative.
  ///
  /// It should be defined on contest(category) level.
  final int delegatesCount;

  /// The voting power associated with this representative, including own and delegated power.
  ///
  /// [Snapshot] wrapper is useful because it may take while to calculate all of voting power.
  /// Also streaming [RepresentativeDetails] may be useful in combination
  /// with [Snapshot] of [votingPower].
  final Snapshot<RepresentativeVotingPower> votingPower;

  /// Profiles are defined on brand level, not campaign but this usually acts as active campaign.
  final RepresentativeProfileDetailsCampaign? campaign;

  /// The delegation status details for the current account regarding this representative.
  final RepresentativeProfileDetailsDelegation delegation;

  /// Creates a [RepresentativeDetails].
  const RepresentativeDetails({
    required this.doc,
    this.template,
    this.versions,
    this.isFavorite = false,
    this.delegatesCount = 0,
    this.votingPower = const Snapshot.idle(),
    this.campaign,
    this.delegation = const RepresentativeProfileDetailsDelegation(),
  });

  /// ID of [doc].
  DocumentRef get id => doc.id;

  // TODO(damian-molinski): Get it from doc metadata.
  /// If [doc] is revoked.
  bool get isRevoked => false;

  @override
  List<Object?> get props => [
    doc,
    template,
    versions,
    isFavorite,
    delegatesCount,
    votingPower,
    campaign,
    delegation,
  ];
}

/// Representative Profiles are defined at brand level, not campaign, so this class does not
/// make much sense at it's related to Representative Nomination or Active Campaign.
///
/// Right now Profile and Nomination is tightly copulated so let it be here for now.
final class RepresentativeProfileDetailsCampaign extends Equatable {
  /// The name of the campaign.
  final String name;

  /// The fund number associated with the campaign.
  final int fundNumber;

  const RepresentativeProfileDetailsCampaign({
    required this.name,
    required this.fundNumber,
  });

  @override
  List<Object?> get props => [name, fundNumber];
}

/// Details about the delegation status relative to the current account.
final class RepresentativeProfileDetailsDelegation extends Equatable {
  /// Indicates if the representative is in the account's delegation builder.
  final bool isInBuilder;

  /// Indicates if the representative is currently representing the account.
  final bool isRepresenting;

  const RepresentativeProfileDetailsDelegation({
    this.isInBuilder = false,
    this.isRepresenting = false,
  });

  @override
  List<Object?> get props => [isInBuilder, isRepresenting];
}
