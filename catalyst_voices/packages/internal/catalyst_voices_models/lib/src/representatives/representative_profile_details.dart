import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class RepresentativeProfileDetails extends Equatable {
  final DocumentRef id;
  final DocumentData doc;
  final DocumentData? template;
  final bool isFavorite;
  final int delegatesCount;
  final Snapshot<RepresentativeVotingPower> votingPower;
  final RepresentativeProfileDetailsCampaign? campaign;
  final RepresentativeProfileDetailsDelegation delegation;

  const RepresentativeProfileDetails({
    required this.id,
    required this.doc,
    this.template,
    this.isFavorite = false,
    this.delegatesCount = 0,
    this.votingPower = const Snapshot.idle(),
    this.campaign,
    this.delegation = const RepresentativeProfileDetailsDelegation(),
  });

  @override
  List<Object?> get props => [];
}

/// Representative Profiles are defined at brand level, not campaign, so this class does not
/// make much sense at it's related to Representative Nomination or Active Campaign.
///
/// Right now Profile and Nomination is tightly copulated to let it be here for now.
final class RepresentativeProfileDetailsCampaign extends Equatable {
  final String name;
  final int fundNumber;

  const RepresentativeProfileDetailsCampaign({
    required this.name,
    required this.fundNumber,
  });

  @override
  List<Object?> get props => [name, fundNumber];
}

final class RepresentativeProfileDetailsDelegation extends Equatable {
  final bool isInBuilder;
  final bool isRepresenting;

  const RepresentativeProfileDetailsDelegation({
    this.isInBuilder = false,
    this.isRepresenting = false,
  });

  @override
  List<Object?> get props => [isInBuilder, isRepresenting];
}
