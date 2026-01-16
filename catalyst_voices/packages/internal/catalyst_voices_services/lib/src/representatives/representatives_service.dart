import 'package:catalyst_voices_models/catalyst_voices_models.dart';

abstract interface class RepresentativesService {
  Future<RepresentativeProfileDetails> getRepresentativeDetails({required DocumentRef profileId});

  Future<void> revokeActiveDelegation();

  Future<void> revokeActiveRepresentation();

  Future<void> submitDelegation(Delegation delegation);

  Future<void> submitRepresentative({
    required CatalystId representativeId,
    required DocumentDataContent payload,
  });

  Future<void> updateRepresentativeFavorite({
    required DocumentRef profileId,
    required bool isFavorite,
  });

  Stream<Delegation?> watchDelegation({required CatalystId delegatorId});

  Stream<Representative?> watchRepresentative({required CatalystId id});

  Stream<RepresentativeProfileDetails> watchRepresentativeDetails({required DocumentRef profileId});

  Stream<Page<RepresentativeProfile>> watchRepresentatives({
    required PageRequest request,
    RepresentativesOrder order,
    RepresentativesFilters filters,
  });
}
