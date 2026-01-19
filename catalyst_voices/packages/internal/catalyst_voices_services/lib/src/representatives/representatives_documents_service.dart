import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/src/representatives/representatives_service.dart';

// TODO(damian-molinski): To be implemented.
/// Implementation of [RepresentativesService].
final class RepresentativesDocumentsService implements RepresentativesService {
  // ignore: unused_field
  final DocumentRepository _documentRepository;

  const RepresentativesDocumentsService(this._documentRepository);

  @override
  Future<RepresentativeDetails> getRepresentativeDetails({required DocumentRef profileId}) {
    throw UnimplementedError();
  }

  @override
  Future<void> revokeDelegation({required CatalystId delegatorId, required Campaign campaign}) {
    throw UnimplementedError();
  }

  @override
  Future<void> revokeRepresentation({
    required CatalystId representativeId,
    required Campaign campaign,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> submitDelegation(Delegation delegation) {
    throw UnimplementedError();
  }

  @override
  Future<Representative> submitRepresentativeProfile({
    required CatalystId representativeId,
    required DocumentDataContent payload,
    required DocumentRef template,
    required Campaign campaign,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateRepresentativeFavorite({
    required DocumentRef profileId,
    required bool isFavorite,
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<Delegation?> watchDelegation({required CatalystId delegatorId}) {
    throw UnimplementedError();
  }

  @override
  Stream<Representative?> watchRepresentative({required CatalystId representativeId}) {
    throw UnimplementedError();
  }

  @override
  Stream<RepresentativeDetails?> watchRepresentativeDetails({required DocumentRef profileId}) {
    throw UnimplementedError();
  }

  @override
  Stream<Page<Representative>> watchRepresentatives({
    required PageRequest request,
    RepresentativesOrder order = const RepresentativesAlphabetical(),
    RepresentativesFilters filters = const RepresentativesFilters(),
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<Page<Representative>> watchRepresentativesCount({
    RepresentativesFilters filters = const RepresentativesFilters(),
  }) {
    throw UnimplementedError();
  }
}
