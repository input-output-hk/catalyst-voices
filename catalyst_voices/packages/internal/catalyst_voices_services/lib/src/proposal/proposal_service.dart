import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:rxdart/rxdart.dart';

abstract interface class ProposalService {
  const factory ProposalService(
    ProposalRepository proposalRepository,
    UserService userService,
    KeyDerivationService keyDerivationService,
    CampaignRepository campaignRepository,
  ) = ProposalServiceImpl;

  Future<List<String>> addFavoriteProposal(String proposalId);

  /// Creates a new proposal draft locally.
  Future<DraftRef> createDraftProposal({
    required DocumentDataContent content,
    required DocumentRef template,
    required SignedDocumentRef categoryId,
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
  /// The local draft referenced by the [document] is removed.
  ///
  /// The [DocumentRef] is retained but it's promoted from [DraftRef]
  /// instance to [SignedDocumentRef] instance.
  Future<SignedDocumentRef> publishProposal({
    required DocumentData document,
  });

  Future<List<String>> removeFavoriteProposal(String proposalId);

  /// Submits a proposal draft into review.
  Future<void> submitProposalForReview({
    required SignedDocumentRef ref,
    required SignedDocumentRef categoryId,
  });

  /// Upserts a proposal draft in the local storage.
  Future<void> upsertDraftProposal({
    required DraftRef selfRef,
    required DocumentDataContent content,
    required DocumentRef template,
    required SignedDocumentRef categoryId,
  });

  Stream<List<Proposal>> watchLatestProposals({int? limit});

  Stream<List<Proposal>> watchUserProposals();
}

final class ProposalServiceImpl implements ProposalService {
  final ProposalRepository _proposalRepository;
  final UserService _userService;
  final KeyDerivationService _keyDerivationService;
  final CampaignRepository _campaignRepository;

  const ProposalServiceImpl(
    this._proposalRepository,
    this._userService,
    this._keyDerivationService,
    this._campaignRepository,
  );

  @override
  Future<List<String>> addFavoriteProposal(String proposalId) async {
    return _proposalRepository.addFavoriteProposal(proposalId);
  }

  @override
  Future<DraftRef> createDraftProposal({
    required DocumentDataContent content,
    required DocumentRef template,
    required SignedDocumentRef categoryId,
  }) async {
    final draftRef = DraftRef.generateFirstRef();
    final catalystId = await _getUserCatalystId();
    await _proposalRepository.upsertDraftProposal(
      document: DocumentData(
        metadata: DocumentDataMetadata(
          type: DocumentType.proposalDocument,
          selfRef: draftRef,
          template: template,
          categoryId: categoryId,
          signers: [catalystId.toString()],
        ),
        content: content,
      ),
    );

    return draftRef;
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
      document: document,
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
  Future<SignedDocumentRef> publishProposal({
    required DocumentData document,
  }) async {
    await _useProposerRoleCredentials(
      (catalystId, privateKey) {
        return _proposalRepository.publishProposal(
          document: document,
          catalystId: catalystId,
          privateKey: privateKey,
        );
      },
    );

    final ref = document.ref;
    if (ref is DraftRef) {
      await _proposalRepository.deleteDraftProposal(ref);
    }

    return ref.toSignedDocumentRef();
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
  Future<void> upsertDraftProposal({
    required DraftRef selfRef,
    required DocumentDataContent content,
    required DocumentRef template,
    required SignedDocumentRef categoryId,
  }) async {
    final catalystId = await _getUserCatalystId();
    await _proposalRepository.upsertDraftProposal(
      document: DocumentData(
        metadata: DocumentDataMetadata(
          type: DocumentType.proposalDocument,
          selfRef: selfRef,
          template: template,
          categoryId: categoryId,
          signers: [catalystId.toString()],
        ),
        content: content,
      ),
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
          final category =
              await _campaignRepository.getCategory(doc.metadata.categoryId);
          final versionsData = versionIds
              .map(
                (e) => BaseProposalData(document: e),
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
              categoryName: category.categoryText,
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

  @override
  Stream<List<Proposal>> watchUserProposals() async* {
    final userCatalystId = await _getUserCatalystId();
    yield* _proposalRepository
        .watchUserProposals(
      userCatalystId: userCatalystId,
    )
        .switchMap((documents) async* {
      final proposals = documents.map((e) async {
        print(e.metadata.categoryId);
        final campaign =
            await _campaignRepository.getCategory(e.metadata.categoryId);
        final proposalData = ProposalData(
          document: e,
          categoryName: campaign.categoryText,
        );
        return Proposal.fromData(proposalData);
      }).toList();
      yield await Future.wait(proposals);
    });
  }

  Future<CatalystId> _getUserCatalystId() async {
    final account = _userService.user.activeAccount;
    if (account == null) {
      throw StateError(
        'Cannot obtain proposer credentials, account missing',
      );
    }

    return account.catalystId.copyWith(
      role: const Optional(AccountRole.proposer),
      rotation: const Optional(0),
    );
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
