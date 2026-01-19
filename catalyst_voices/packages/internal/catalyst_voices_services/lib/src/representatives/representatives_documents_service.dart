import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/src/representatives/representatives_service.dart';

final class RepresentativesDocumentsService implements RepresentativesService {
  // ignore: unused_field
  final DocumentRepository _documentRepository;

  const RepresentativesDocumentsService(this._documentRepository);

  @override
  Future<RepresentativeDetails> getRepresentativeDetails({required DocumentRef profileId}) {
    // TODO: implement getRepresentativeDetails
    throw UnimplementedError();
  }

  @override
  Future<void> revokeDelegation({required CatalystId delegatorId, required Campaign campaign}) {
    // TODO: implement revokeDelegation
    throw UnimplementedError();
  }

  @override
  Future<void> revokeRepresentation({
    required CatalystId representativeId,
    required Campaign campaign,
  }) {
    // TODO: implement revokeRepresentation
    throw UnimplementedError();
  }

  @override
  Future<void> submitDelegation(Delegation delegation) {
    // TODO: implement submitDelegation
    throw UnimplementedError();
  }

  @override
  Future<Representative> submitRepresentativeProfile({
    required CatalystId representativeId,
    required DocumentDataContent payload,
    required DocumentRef template,
    required Campaign campaign,
  }) {
    // TODO: implement submitRepresentativeProfile
    throw UnimplementedError();
  }

  @override
  Future<void> updateRepresentativeFavorite({
    required DocumentRef profileId,
    required bool isFavorite,
  }) {
    // TODO: implement updateRepresentativeFavorite
    throw UnimplementedError();
  }

  @override
  Stream<Delegation?> watchDelegation({required CatalystId delegatorId}) {
    // TODO: implement watchDelegation
    throw UnimplementedError();
  }

  @override
  Stream<Representative?> watchRepresentative({required CatalystId representativeId}) {
    // TODO: implement watchRepresentative
    throw UnimplementedError();
  }

  @override
  Stream<RepresentativeDetails?> watchRepresentativeDetails({required DocumentRef profileId}) {
    // TODO: implement watchRepresentativeDetails
    throw UnimplementedError();
  }

  @override
  Stream<Page<Representative>> watchRepresentatives({
    required PageRequest request,
    RepresentativesOrder order = const RepresentativesAlphabetical(),
    RepresentativesFilters filters = const RepresentativesFilters(),
  }) {
    // TODO: implement watchRepresentatives
    throw UnimplementedError();
  }

  @override
  Stream<Page<Representative>> watchRepresentativesCount({
    RepresentativesFilters filters = const RepresentativesFilters(),
  }) {
    // TODO: implement watchRepresentativesCount
    throw UnimplementedError();
  }
}
