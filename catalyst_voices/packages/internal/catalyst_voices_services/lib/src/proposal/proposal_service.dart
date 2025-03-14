import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/src/crypto/key_derivation_service.dart';
import 'package:catalyst_voices_services/src/user/user_service.dart';
import 'package:rxdart/rxdart.dart';

abstract interface class ProposalService {
  const factory ProposalService(
    ProposalRepository proposalRepository,
    UserService userService,
    KeyDerivationService keyDerivationService,
  ) = ProposalServiceImpl;

  Future<List<String>> addFavoriteProposal(String proposalId);

  Future<DraftRef> createDraftProposal({
    required DocumentDataContent content,
    required SignedDocumentRef template,
    DraftRef? ref,
  });

  /// Delete a draft proposal from local storage.
  ///
  /// Published proposals cannot be deleted.
  Future<void> deleteDraftProposal(DraftRef ref);

  /// Encodes the [document] to exportable format.
  ///
  /// It does not save the document anywhere on the disk,
  /// it only encodes a document as [Uint8List]
  /// so that it can be saved as a file.
  Future<Uint8List> encodeProposalForExport({
    required DocumentData document,
  });

  /// Fetches favorites proposals ids of the user
  Future<List<String>> getFavoritesProposalsIds();

  Future<ProposalData> getProposal({
    required DocumentRef ref,
  });

  Future<ProposalPaginationItems<Proposal>> getProposals({
    required ProposalPaginationRequest request,
  });

  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef ref,
  });

  /// Fetches user's proposals ids  depending on his id that is saved
  /// in metadata of proposal document
  Future<List<String>> getUserProposalsIds(String userId);

  /// Imports the proposal from [data] encoded by [encodeProposalForExport].
  ///
  /// The proposal reference will be altered to avoid linking
  /// the imported proposal to the old proposal.
  ///
  /// Once imported from the version management point of view this becomes
  /// a new standalone proposal not related to the previous one.
  Future<DocumentRef> importProposal(Uint8List data);

  /// Publishes a public proposal draft.
  Future<void> publishProposal({
    required DocumentData document,
  });

  Future<List<String>> removeFavoriteProposal(String proposalId);

  /// Submits a proposal draft into review.
  Future<void> submitProposalForReview({
    required SignedDocumentRef ref,
    required SignedDocumentRef categoryId,
  });

  /// Saves a new proposal draft in the local storage.
  Future<void> updateDraftProposal({
    required DraftRef ref,
    required DocumentDataContent content,
  });

  Stream<List<Proposal>> watchLatestProposals({int? limit});
}

final class ProposalServiceImpl implements ProposalService {
  final ProposalRepository _proposalRepository;
  final UserService _userService;
  final KeyDerivationService _keyDerivationService;

  const ProposalServiceImpl(
    this._proposalRepository,
    this._userService,
    this._keyDerivationService,
  );

  @override
  Future<List<String>> addFavoriteProposal(String proposalId) async {
    return _proposalRepository.addFavoriteProposal(proposalId);
  }

  @override
  Future<DraftRef> createDraftProposal({
    required DocumentDataContent content,
    required SignedDocumentRef template,
    DraftRef? ref,
  }) async {
    return _proposalRepository.createDraftProposal(
      content: content,
      template: template,
      selfRef: ref,
    );
  }

  @override
  Future<void> deleteDraftProposal(DraftRef ref) {
    return _proposalRepository.deleteDraftProposal(ref);
  }

  @override
  Future<Uint8List> encodeProposalForExport({
    required DocumentData document,
  }) {
    return _proposalRepository.encodeProposalForExport(
      metadata: metadata,
      content: content,
    );
  }

  @override
  Future<List<String>> getFavoritesProposalsIds() async {
    final proposalsIds = await _proposalRepository.getFavoritesProposalsIds();
    return proposalsIds;
  }

  @override
  Future<ProposalData> getProposal({
    required DocumentRef ref,
  }) async {
    return _proposalRepository.getProposal(ref: ref);

  }

  @override
  Future<ProposalPaginationItems<Proposal>> getProposals({
    required ProposalPaginationRequest request,
  }) async {
    final proposals = await _proposalRepository.getProposals(
      request: request,
    );

    return ProposalPaginationItems(
      items: proposals.proposals,
      pageKey: request.pageKey,
      maxResults: proposals.maxResults,
    );
  }

  @override
  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef ref,
  }) async {
    final proposalTemplate = await _proposalRepository.getProposalTemplate(
      ref: ref,
    );

    return proposalTemplate;
  }

  @override
  Future<List<String>> getUserProposalsIds(String userId) async {
    final proposalsIds = await _proposalRepository.getUserProposalsIds(userId);
    return proposalsIds;
  }

  @override
  Future<DocumentRef> importProposal(Uint8List data) {
    return _proposalRepository.importProposal(data);
  }

  @override
  Future<void> publishProposal({
    required DocumentData document,
  }) {
    return _useProposerRoleCredentials(
      (catalystId, privateKey) {
        return _proposalRepository.publishProposal(
          document: document,
          catalystId: catalystId,
          privateKey: privateKey,
        );
      },
    );
  }

  @override
  Future<List<String>> removeFavoriteProposal(String proposalId) async {
    return _proposalRepository.removeFavoriteProposal(proposalId);
  }

  @override
  Future<void> submitProposalForReview({
    required SignedDocumentRef ref,
    required SignedDocumentRef categoryId,
  }) {
    return _useProposerRoleCredentials(
      (catalystId, privateKey) {
        return _proposalRepository.publishProposalAction(
          ref: ref,
          categoryId: categoryId,
          action: ProposalSubmissionAction.aFinal,
          catalystId: catalystId,
          privateKey: privateKey,
        );
      },
    );
  }

  @override
  Future<void> updateDraftProposal({
    required DraftRef ref,
    required DocumentDataContent content,
  }) {
    return _proposalRepository.updateDraftProposal(
      ref: ref,
      content: content,
    );
  }

  @override
  Stream<List<Proposal>> watchLatestProposals({int? limit}) {
    return _proposalRepository
        .watchLatestProposals(limit: limit)
        .switchMap((documents) async* {
      final proposalsStreams = await Future.wait(
        documents.map((doc) async {
          final versionIds = await _proposalRepository.queryVersionsOfId(
            id: doc.metadata.selfRef.id,
          );
          final versionsData = versionIds
              .map(
                (e) => BaseProposalData(
                  document: e,
                ),
              )
              .toList();

          return _proposalRepository
              .watchCount(
            ref: doc.metadata.selfRef,
            type: DocumentType.commentTemplate,
          )
              .map((commentsCount) {
            final proposalData = ProposalData(
              document: doc,
              categoryId: DocumentType.categoryParametersDocument.uuid,
              versions: versionsData,
              commentsCount: commentsCount,
            );
            return Proposal.fromData(proposalData);
          });
        }),
      );

      await for (final commentsUpdates in Rx.combineLatest(
        proposalsStreams,
        (List<Proposal> proposals) => proposals,
      )) {
        yield commentsUpdates;
      }
    });
  }

  Future<void> _useProposerRoleCredentials(
    Future<void> Function(
      CatalystId catalystId,
      CatalystPrivateKey privateKey,
    ) callback,
  ) async {
    final account = _userService.user.activeAccount;
    if (account == null) {
      throw StateError(
        'Cannot obtain proposer credentials, account missing',
      );
    }

    final catalystId = account.catalystId.copyWith(
      role: const Optional(AccountRole.proposer),
      rotation: const Optional(0),
    );

    await account.keychain.getMasterKey().use((masterKey) async {
      final keyPair = _keyDerivationService.deriveAccountRoleKeyPair(
        masterKey: masterKey,
        role: AccountRole.proposer,
      );

      await keyPair.use(
        (keyPair) => callback(catalystId, keyPair.privateKey),
      );
    });
  }
}
