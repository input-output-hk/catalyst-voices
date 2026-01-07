import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/api/local/fixture/fixtures.dart';
import 'package:catalyst_voices_repositories/src/api/models/current_page.dart';
import 'package:catalyst_voices_repositories/src/api/models/document_index_list.dart';
import 'package:catalyst_voices_repositories/src/api/models/document_index_query_filter.dart';
import 'package:catalyst_voices_repositories/src/api/models/document_reference.dart';
import 'package:catalyst_voices_repositories/src/api/models/full_stake_info.dart';
import 'package:catalyst_voices_repositories/src/api/models/indexed_document.dart';
import 'package:catalyst_voices_repositories/src/api/models/indexed_document_version.dart';
import 'package:catalyst_voices_repositories/src/api/models/key_data.dart';
import 'package:catalyst_voices_repositories/src/api/models/network.dart';
import 'package:catalyst_voices_repositories/src/api/models/payment_data.dart';
import 'package:catalyst_voices_repositories/src/api/models/rbac_registration_chain.dart';
import 'package:catalyst_voices_repositories/src/api/models/rbac_role_data.dart';
import 'package:catalyst_voices_repositories/src/api/models/stake_info.dart';
import 'package:catalyst_voices_repositories/src/dto/config/remote_config.dart';
import 'package:catalyst_voices_repositories/src/signed_document/signed_document_mapper.dart';
import 'package:cbor/cbor.dart';
import 'package:collection/collection.dart';
import 'package:uuid_plus/uuid_plus.dart' as u;

var _time = DateTime.timestamp().millisecondsSinceEpoch;

String _testAccountAuthorGetter(DocumentRef ref) {
  /* cSpell:disable */
  return 'id.catalyst://Test@preprod.cardano/kouGJuMn6o18rRpDAZ1oiZadK171f5_-hgcHTYDGbo0=';
  /* cSpell:enable */
}

String _v7() {
  final config = u.V7Options(_time -= 2000, null);
  return const u.Uuid().v7(config: config);
}

typedef DocumentAuthorGetter = String Function(DocumentRef ref);

final class LocalCatGateway implements CatGatewayService {
  final _cache = <String, List<DocumentDataMetadata>>{};
  final _docs = <DocumentDataMetadata, Uint8List>{};
  final _cachePopulateCompleter = Completer<bool>();

  final int proposalsCount;
  final bool decompressedDocuments;
  final DocumentAuthorGetter authorGetter;

  factory LocalCatGateway.create({
    int initialProposalsCount = 100,
    bool decompressedDocuments = false,
    DocumentAuthorGetter authorGetter = _testAccountAuthorGetter,
  }) {
    return LocalCatGateway._(
      proposalsCount: initialProposalsCount,
      decompressedDocuments: decompressedDocuments,
      authorGetter: authorGetter,
    );
  }

  LocalCatGateway._({
    required this.proposalsCount,
    required this.decompressedDocuments,
    required this.authorGetter,
  }) {
    unawaited(_populateIndex());
  }

  @override
  void close() {}

  @override
  Future<DocumentIndexList> documentIndex({
    required DocumentIndexQueryFilter filter,
    int? limit,
    int? page,
  }) async {
    page ??= 0;
    limit ??= 10;

    await _cachePopulateCompleter.future;

    final id = filter.id;
    final eq = id?.eq;
    if (eq != null) {
      final versions = _cache[eq] ?? [];

      return DocumentIndexList(
        docs: [versions.asIndex(eq)],
        page: CurrentPage(
          page: page,
          limit: limit,
          remaining: 0,
        ),
      );
    }

    final docs = _cache.entries
        .skip(page * limit)
        .take(limit)
        .map((e) => e.value.asIndex(e.key))
        .toList();

    final currentPage = CurrentPage(
      page: page,
      limit: limit,
      remaining: _cache.length - (page * limit + docs.length),
    );

    return DocumentIndexList(
      docs: docs,
      page: currentPage,
    );
  }

  @override
  Future<RemoteConfig> frontendConfig({
    dynamic authorization,
    dynamic contentType,
  }) async {
    return const RemoteConfig();
  }

  @override
  Future<Uint8List> getDocument({
    required String documentId,
    String? version,
  }) async {
    await _cachePopulateCompleter.future;

    if (!_cache.containsKey(documentId)) {
      throw const NotFoundException();
    }

    final versions = _cache[documentId]!;
    final metadata = version != null
        ? versions.firstWhereOrNull((e) => e.id.ver == version)
        : versions.last;
    if (metadata == null) {
      throw const NotFoundException();
    }

    final bytes = _docs[metadata] ?? _buildDoc(metadata);

    return bytes;
  }

  @override
  Future<RbacRegistrationChain> rbacRegistration({
    String? lookup,
    bool? showAllInvalid = false,
  }) async {
    /* cSpell:disable */
    return RbacRegistrationChain(
      catalystId: lookup!,
      lastPersistentTxn: '0x784433f2735daf8d2cc28c383c49f195cbe7913c8e242cc47d900a11407e3ced',
      purpose: ['ca7a1457-ef9f-4c7f-9c74-7f8c4a4cfa6c'],
      roles: [
        RbacRoleData(
          roleId: 0,
          signingKeys: [
            KeyData(
              isPersistent: true,
              time: DateTime.parse('2025-10-08T12:31:35+00:00'),
              slot: 1,
              txnIndex: 1,
              keyType: CertificateType.x509,
            ),
          ],
          paymentAddresses: [
            PaymentData(
              isPersistent: true,
              time: DateTime.parse('2025-10-08T12:31:35+00:00'),
              slot: 1,
              txnIndex: 1,
            ),
          ],
        ),
        RbacRoleData(
          roleId: 3,
          signingKeys: [
            KeyData(
              isPersistent: true,
              time: DateTime.parse('2025-10-08T12:31:35+00:00'),
              slot: 1,
              txnIndex: 1,
              keyType: CertificateType.x509,
            ),
          ],
          paymentAddresses: [
            PaymentData(
              isPersistent: true,
              time: DateTime.parse('2025-10-08T12:31:35+00:00'),
              slot: 1,
              txnIndex: 1,
            ),
          ],
        ),
      ],
    );
    /* cSpell:enable */
  }

  @override
  Future<FullStakeInfo> stakeAssets({
    String? stakeAddress,
    Network? network,
    String? asat,
    String? authorization,
  }) async {
    return const FullStakeInfo(
      volatile: StakeInfo(
        adaAmount: 9992646426,
        slotNumber: 104243495,
        assets: [],
      ),
      persistent: StakeInfo(
        adaAmount: 9992646426,
        slotNumber: 104243495,
        assets: [],
      ),
    );
  }

  @override
  Future<void> uploadDocument({required Uint8List body}) async {}

  Uint8List _buildDoc(
    DocumentDataMetadata metadata, {
    ProposalSubmissionAction? action,
  }) {
    final protectedHeaders = SignedDocumentMapper.buildCoseProtectedHeaders(metadata);

    final payload = switch (metadata.type) {
      DocumentType.proposalDocument when decompressedDocuments => decompressedProposalPayload,
      DocumentType.proposalDocument => compressedProposalPayload,
      DocumentType.proposalTemplate when decompressedDocuments =>
        decompressedProposalTemplatePayload,
      DocumentType.proposalTemplate => compressedProposalTemplatePayload,
      DocumentType.commentDocument when decompressedDocuments => decompressedCommentPayload,
      DocumentType.commentDocument => compressedCommentPayload,
      DocumentType.commentTemplate when decompressedDocuments => decompressedCommentTemplatePayload,
      DocumentType.commentTemplate => compressedCommentTemplatePayload,
      DocumentType.proposalActionDocument when decompressedDocuments => switch (action) {
        null || ProposalSubmissionAction.aFinal => decompressedProposalActionFinalPayload,
        ProposalSubmissionAction.draft => decompressedProposalActionDraftPayload,
        ProposalSubmissionAction.hide => decompressedProposalActionHidePayload,
      },
      DocumentType.proposalActionDocument => switch (action) {
        null || ProposalSubmissionAction.aFinal => compressedProposalActionFinalPayload,
        ProposalSubmissionAction.draft => compressedProposalActionDraftPayload,
        ProposalSubmissionAction.hide => compressedProposalActionHidePayload,
      },
      DocumentType.categoryParametersDocument ||
      DocumentType.categoryParametersTemplate ||
      DocumentType.campaignParametersDocument ||
      DocumentType.campaignParametersTemplate ||
      DocumentType.brandParametersDocument ||
      DocumentType.brandParametersTemplate ||
      DocumentType.unknown => throw UnimplementedError(),
    };

    final ref = SignedDocumentRef(id: metadata.id.id, ver: metadata.id.ver);
    final signature = CoseSignature(
      protectedHeaders: CoseHeaders.protected(
        kid: CatalystIdKid(utf8.encode(authorGetter(ref))),
      ),
      unprotectedHeaders: const CoseHeaders.unprotected(),
      signature: Uint8List.fromList([]),
    );

    final coseSign = CoseSign(
      protectedHeaders: protectedHeaders,
      unprotectedHeaders: const CoseHeaders.unprotected(),
      payload: payload,
      signatures: [signature],
    );

    return Uint8List.fromList(cbor.encode(coseSign.toCbor(tagged: false)));
  }

  Future<void> _populateIndex() async {
    try {
      final activeConstantDocumentRefs = constantDocumentRefsPerCampaign(activeCampaignRef);
      if (activeConstantDocumentRefs.isEmpty) return;

      for (final constRefs in activeConstantDocumentRefs) {
        final proposal = constRefs.proposal;
        final comment = constRefs.comment;
        if (proposal != null) {
          _cache[proposal.id] = [
            DocumentDataMetadata.proposalTemplate(
              id: SignedDocumentRef(id: proposal.id, ver: proposal.ver),
              parameters: DocumentParameters({constRefs.category}),
            ),
          ];
        }

        if (comment != null) {
          _cache[comment.id] = [
            DocumentDataMetadata.commentTemplate(
              id: SignedDocumentRef(id: comment.id, ver: comment.ver),
              parameters: DocumentParameters({constRefs.category}),
            ),
          ];
        }
      }

      for (var i = 0; i < proposalsCount; i++) {
        final id = _v7();
        const versionsCount = 2;

        // only first 4 are used
        final categoryConstRefs = activeConstantDocumentRefs[3 & i];
        final proposal = categoryConstRefs.proposal;
        if (proposal == null) {
          continue;
        }

        for (var j = 0; j < versionsCount; j++) {
          final ver = j == 0 ? id : _v7();

          final proposalId = SignedDocumentRef(id: id, ver: ver);
          final proposalMetadata = DocumentDataMetadata.proposal(
            id: proposalId,
            template: proposal,
            parameters: DocumentParameters({categoryConstRefs.category}),
            authors: const [],
          );
          _cache.update(
            id,
            (value) => value..add(proposalMetadata),
            ifAbsent: () => [proposalMetadata],
          );

          final comment = categoryConstRefs.proposal;
          if (comment != null) {
            const commentsCount = 2;
            for (var c = 0; c < commentsCount; c++) {
              final commentId = _v7();
              _cache[commentId] = [
                DocumentDataMetadata.comment(
                  id: SignedDocumentRef(id: commentId, ver: commentId),
                  template: comment,
                  proposalRef: proposalId,
                  parameters: DocumentParameters({categoryConstRefs.category}),
                  authors: const [],
                ),
              ];
            }
          }

          final actionIndex = (ProposalSubmissionAction.values.length + 1) & i;
          final action = ProposalSubmissionAction.values.elementAtOrNull(actionIndex);
          if (action != null) {
            final actionId = _v7();

            final actionMetadata = DocumentDataMetadata.proposalAction(
              id: SignedDocumentRef(id: actionId, ver: actionId),
              proposalRef: proposalId,
              parameters: DocumentParameters({categoryConstRefs.category}),
            );

            _cache[actionId] = [actionMetadata];
            _docs[actionMetadata] = _buildDoc(actionMetadata, action: action);
          }
        }
      }

      _cachePopulateCompleter.complete(true);
    } catch (error, stack) {
      print('populate index failed');
      print('$error');
      print('$stack');
    }
  }
}

extension on List<DocumentDataMetadata> {
  IndexedDocument asIndex(String id) {
    return IndexedDocument(
      id: id,
      ver: map((e) => e.toIndexVersion()).toList(),
    );
  }
}

extension on DocumentDataMetadata {
  IndexedDocumentVersion toIndexVersion() {
    return IndexedDocumentVersion(
      id: id.id,
      ver: id.ver!,
      type: type.uuid,
      ref: [
        ?ref?.toRef(),
      ],
      reply: [
        ?reply?.toRef(),
      ],
      template: [
        ?template?.toRef(),
      ],
      parameters: parameters.set.map((e) => e.toRef()).toList(),
      collaborators: collaborators?.map((e) => e.toString()).toList(),
    );
  }
}

extension on DocumentRef {
  DocumentReference toRef() {
    return DocumentReference(id: id, ver: ver!);
  }
}
