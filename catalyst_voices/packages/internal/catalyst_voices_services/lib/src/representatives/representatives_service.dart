import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/src/representatives/representatives_documents_service.dart';

/// Service for managing representatives and delegations.
abstract interface class RepresentativesService {
  const factory RepresentativesService(DocumentRepository documentRepository) =
      RepresentativesDocumentsService;

  /// Retrieves detailed information about a representative's profile.
  ///
  /// Throws [DocumentNotFoundException] if document with [profileId] is not found.
  /// Throws [DocumentRevokedException] if document with [profileId] is found but revoked.
  Future<RepresentativeDetails> getRepresentativeDetails({required DocumentRef profileId});

  /// Revokes all delegations of [delegatorId] made for [campaign].
  Future<void> revokeDelegation({
    required CatalystId delegatorId,
    required Campaign campaign,
  });

  /// Revokes representative profile of [representativeId] and all nomination for [campaign].
  Future<void> revokeRepresentation({
    required CatalystId representativeId,
    required Campaign campaign,
  });

  /// Submits a new delegation or updates existing for [Delegation.delegatorId].
  Future<void> submitDelegation(Delegation delegation);

  /// Submits a representative profile update or creates new, based on [template], with nominations
  /// for all [campaign] categories.
  ///
  /// Returns created [Representative] object with reference to profile.
  Future<Representative> submitRepresentativeProfile({
    required CatalystId representativeId,
    required DocumentDataContent payload,
    required DocumentRef template,
    required Campaign campaign,
  });

  /// Updates the favorite status of a representative.
  Future<void> updateRepresentativeFavorite({
    required DocumentRef profileId,
    required bool isFavorite,
  });

  /// Watches the delegation status for a specific delegator.
  /// Usually used for active account.
  ///
  /// If delegation is found but revoked this method will emit null.
  Stream<Delegation?> watchDelegation({required CatalystId delegatorId});

  /// Watches for changes to a specific representative.
  /// Usually used for active account.
  ///
  /// If profile is found but revoked this method will emit null.
  Stream<Representative?> watchRepresentative({
    required CatalystId representativeId,
  });

  /// Watches for changes to a representative's profile details.
  /// Usually used when displaying specific representative profile details.
  ///
  /// Emits null if document with [profileId] is not found.
  Stream<RepresentativeDetails?> watchRepresentativeDetails({required DocumentRef profileId});

  /// Watches a paginated list of representatives based on [filters] and [order].
  Stream<Page<Representative>> watchRepresentatives({
    required PageRequest request,
    RepresentativesOrder order,
    RepresentativesFilters filters,
  });

  /// Watches representatives count based on [filters].
  Stream<Page<Representative>> watchRepresentativesCount({
    RepresentativesFilters filters,
  });
}
