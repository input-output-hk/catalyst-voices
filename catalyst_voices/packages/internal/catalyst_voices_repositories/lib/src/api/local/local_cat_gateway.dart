import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.enums.swagger.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.models.swagger.dart';
import 'package:catalyst_voices_repositories/src/api/local/fixture/fixtures.dart';
import 'package:catalyst_voices_repositories/src/dto/api/document_index_list_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/api/document_index_query_filters_dto.dart'
    show IdSelectorDto;
import 'package:cbor/cbor.dart';
import 'package:chopper/chopper.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:uuid_plus/uuid_plus.dart' as u;

/* cSpell:disable */
const _collabId =
    'id.catalyst://CollabA@preprod.cardano/AQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQE=';

var _time = DateTime.utc(2025, 12, 19, 20, 3).millisecondsSinceEpoch;

String _testAccountAuthorGetter(DocumentRef ref) {
  /* cSpell:disable */
  return 'id.catalyst://Test@preprod.cardano/kouGJuMn6o18rRpDAZ1oiZadK171f5_-hgcHTYDGbo0=';
  /* cSpell:enable */
}
/* cSpell:enable */

String _v7() {
  final rand = Uint8List.fromList([42, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
  final config = u.V7Options(_time -= 2000, rand);
  return const u.Uuid().v7(config: config);
}

typedef DocumentAuthorGetter = String Function(DocumentRef ref);

final class LocalCatGateway implements CatGateway {
  @override
  ChopperClient client;

  final _cache = <String, List<SignedDocumentMetadata>>{};
  final _docs = <SignedDocumentMetadata, Uint8List>{};
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
      ChopperClient(),
      proposalsCount: initialProposalsCount,
      decompressedDocuments: decompressedDocuments,
      authorGetter: authorGetter,
    );
  }

  LocalCatGateway._(
    this.client, {
    required this.proposalsCount,
    required this.decompressedDocuments,
    required this.authorGetter,
  }) {
    unawaited(_populateIndex());
  }

  @override
  Type get definitionType => CatGateway;

  @override
  Future<Response<FullStakeInfo>> apiV1CardanoAssetsStakeAddressGet({
    required String? stakeAddress,
    Network? network,
    String? asat,
    dynamic authorization,
    dynamic contentType,
  }) async {
    const body = FullStakeInfo(
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
    return Response<FullStakeInfo>(http.Response('{}', 200), body);
  }

  @override
  Future<Response<Object>> apiV1ConfigFrontendGet({
    dynamic authorization,
    dynamic contentType,
  }) async {
    return Response<Object>(http.Response('{}', 200), const <String, dynamic>{});
  }

  @override
  Future<Response<String>> apiV1DocumentDocumentIdGet({
    required String? documentId,
    String? version,
    dynamic authorization,
    dynamic contentType,
  }) async {
    await _cachePopulateCompleter.future;

    if (documentId == null || !_cache.containsKey(documentId)) {
      return Response(http.Response.bytes([], 404), '');
    }

    final versions = _cache[documentId]!;
    final metadata = version != null
        ? versions.firstWhereOrNull((e) => e.ver == version)
        : versions.last;
    if (metadata == null) {
      return Response(http.Response.bytes([], 404), '');
    }

    final bytes = _docs[metadata] ?? _buildDoc(metadata);

    return Response(http.Response.bytes(bytes, 200), '');
  }

  @override
  Future<Response<DocumentIndexList>> apiV1DocumentIndexPost({
    int? page,
    int? limit,
    dynamic authorization,
    dynamic contentType,
    required DocumentIndexQueryFilter? body,
  }) async {
    page ??= 0;
    limit ??= 10;

    await _cachePopulateCompleter.future;

    final id = body?.id as IdSelectorDto?;
    final eq = id?.eq;
    if (eq != null) {
      final versions = _cache[eq] ?? [];
      return Response(
        http.Response('{}', 200),
        DocumentIndexList(
          docs: [versions.asIndex(eq)],
          page: CurrentPage(
            page: page,
            limit: limit,
            remaining: 0,
          ),
        ),
      );
    }

    final docs = _cache.entries
        .skip(page * limit)
        .take(limit)
        .map((e) => e.value.asIndex(e.key))
        .map((e) => e.toJson())
        .toList();

    final currentPage = CurrentPage(
      page: page,
      limit: limit,
      remaining: _cache.length - (page * limit + docs.length),
    );

    final rBody = DocumentIndexList(
      docs: docs,
      page: currentPage,
    );
    return Response(http.Response('{}', 200), rBody);
  }

  @override
  Future<Response<dynamic>> apiV1DocumentPut({
    dynamic authorization,
    dynamic contentType,
    required Object? body,
  }) async {
    return Response(http.Response('{}', 200), 'ok');
  }

  @override
  Future<Response<RbacRegistrationChain>> apiV1RbacRegistrationGet({
    String? lookup,
    dynamic authorization,
    dynamic contentType,
  }) async {
    /* cSpell:disable */
    final body = RbacRegistrationChain(
      catalystId: lookup!,
      lastPersistentTxn: '0x784433f2735daf8d2cc28c383c49f195cbe7913c8e242cc47d900a11407e3ced',
      purpose: ['ca7a1457-ef9f-4c7f-9c74-7f8c4a4cfa6c'],
      roles: {
        '0': {
          'payment_addresses': [
            {
              'address':
                  'addr_test1qpmezqgmgrpr79yltv05nrxzcfz4x5cmq936wftp5zvdz34fe77rv376n6wqpuf77es9t2xlwx5cmf0grv47ted2m3yqdfy2ra',
              'is_persistent': true,
              'time': '2025-10-08T12:31:35+00:00',
            },
          ],
          'signing_keys': [
            {
              'is_persistent': true,
              'key_type': 'x509',
              'key_value':
                  '0x308201173081caa00302010202046c59e362300506032b657030003022180f32303235313030383132333130375a180f39393939313233313233353935395a3000302a300506032b65700321007acd769a3df35a98921901b8bba58b0c7d284a1a439c5b4aba7e68de3b1195f6a3623060305e0603551d110457305586537765622b63617264616e6f3a2f2f616464722f7374616b655f7465737431757a35756c30706b676c64666138717137796c3076637a343472306872327664356835706b326c39756b3464636a71706b63736d37300506032b657003410045a38c8c40ec45786d9add539853cd461b7b98ae150b07c61f5f954647d95b358b35e7b96a1cc4d047b41b491c27d19306f682f7c3fcbc48318b13742b93da0d',
              'time': '2025-10-08T12:31:35+00:00',
            },
          ],
        },
        '3': {
          'payment_addresses': [
            {
              'address':
                  'addr_test1qpmezqgmgrpr79yltv05nrxzcfz4x5cmq936wftp5zvdz34fe77rv376n6wqpuf77es9t2xlwx5cmf0grv47ted2m3yqdfy2ra',
              'is_persistent': true,
              'time': '2025-10-08T12:31:35+00:00',
            },
          ],
          'signing_keys': [
            {
              'is_persistent': true,
              'key_type': 'pubkey',
              'key_value': '0x4dc09a04607b6915424f22ee815dcc9b18213f49d8ed4bd231bc9d040eb248ae',
              'time': '2025-10-08T12:31:35+00:00',
            },
          ],
        },
      },
    );
    /* cSpell:enable */
    return Response<RbacRegistrationChain>(
      http.Response('{}', 200),
      body,
    );
  }

  Uint8List _buildDoc(
    SignedDocumentMetadata metadata, {
    ProposalSubmissionAction? action,
    DocumentAuthorGetter? authorGetter,
  }) {
    final protectedHeaders = CoseHeaders.protected(
      contentType: const IntValue(CoseValues.jsonContentType),
      // ignore: avoid_redundant_argument_values
      contentEncoding: decompressedDocuments
          ? null
          : const StringValue(CoseValues.brotliContentEncoding),
      type: metadata.documentType.uuid.asCose,
      id: metadata.id!.asCose,
      ver: metadata.ver!.asCose,
      ref: metadata.ref?.asCose,
      template: metadata.template?.asCose,
      reply: metadata.reply?.asCose,
      collabs: metadata.collabs,
      categoryId: metadata.categoryId?.asCose,
    );

    final payload = switch (metadata.documentType) {
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
      DocumentType.reviewDocument ||
      DocumentType.reviewTemplate ||
      DocumentType.categoryParametersDocument ||
      DocumentType.categoryParametersTemplate ||
      DocumentType.campaignParametersDocument ||
      DocumentType.campaignParametersTemplate ||
      DocumentType.brandParametersDocument ||
      DocumentType.brandParametersTemplate ||
      DocumentType.unknown => throw UnimplementedError(),
    };

    final ref = SignedDocumentRef(id: metadata.id!, ver: metadata.ver);
    final signature = CoseSignature(
      protectedHeaders: CoseHeaders.protected(
        kid: utf8.encode((authorGetter ?? this.authorGetter)(ref)),
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
    for (final constRefs in activeConstantDocumentRefs) {
      _cache[constRefs.proposal.id] = [
        SignedDocumentMetadata(
          contentType: SignedDocumentContentType.json,
          documentType: DocumentType.proposalTemplate,
          id: constRefs.proposal.id,
          ver: constRefs.proposal.ver,
          categoryId: constRefs.category.asMetadataRef,
        ),
      ];

      _cache[constRefs.comment.id] = [
        SignedDocumentMetadata(
          contentType: SignedDocumentContentType.json,
          documentType: DocumentType.commentTemplate,
          id: constRefs.comment.id,
          ver: constRefs.comment.ver,
          categoryId: constRefs.category.asMetadataRef,
        ),
      ];
    }

    for (var i = 0; i < proposalsCount; i++) {
      final id = _v7();
      const versionsCount = 2;

      // only first 4 are used
      final categoryConstRefs = activeConstantDocumentRefs[3 & i];

      for (var j = 0; j < versionsCount; j++) {
        final ver = j == 0 ? id : _v7();

        final proposalMetadata = SignedDocumentMetadata(
          contentType: SignedDocumentContentType.json,
          documentType: DocumentType.proposalDocument,
          id: id,
          ver: ver,
          template: categoryConstRefs.proposal.asMetadataRef,
          categoryId: categoryConstRefs.category.asMetadataRef,
          collabs: const [_collabId],
        );
        _cache.update(
          id,
          (value) => value..add(proposalMetadata),
          ifAbsent: () => [proposalMetadata],
        );

        const commentsCount = 2;
        for (var c = 0; c < commentsCount; c++) {
          final commentId = _v7();
          _cache[commentId] = [
            SignedDocumentMetadata(
              contentType: SignedDocumentContentType.json,
              documentType: DocumentType.commentDocument,
              id: commentId,
              ver: commentId,
              ref: SignedDocumentMetadataRef(id: id, ver: ver),
              template: categoryConstRefs.comment.asMetadataRef,
              categoryId: categoryConstRefs.category.asMetadataRef,
            ),
          ];
        }

        final actionIndex = (ProposalSubmissionAction.values.length + 1) & i;
        final action = ProposalSubmissionAction.values.elementAtOrNull(actionIndex);
        if (action != null) {
          final actionId = _v7();

          final actionMetadata = SignedDocumentMetadata(
            contentType: SignedDocumentContentType.json,
            documentType: DocumentType.proposalActionDocument,
            id: actionId,
            ver: actionId,
            ref: SignedDocumentMetadataRef(id: id, ver: ver),
            categoryId: categoryConstRefs.category.asMetadataRef,
          );

          _cache[actionId] = [actionMetadata];
          _docs[actionMetadata] = _buildDoc(
            actionMetadata,
            action: action,
          );
        }

        for (final collab in proposalMetadata.collabs ?? <String>[]) {
          final collabActionId = _v7();
          const collabAction = ProposalSubmissionAction.draft;

          final collabActionMetadata = SignedDocumentMetadata(
            contentType: SignedDocumentContentType.json,
            documentType: DocumentType.proposalActionDocument,
            id: collabActionId,
            ver: collabActionId,
            ref: SignedDocumentMetadataRef(id: id, ver: ver),
            categoryId: categoryConstRefs.category.asMetadataRef,
          );

          _cache[collabActionId] = [collabActionMetadata];
          _docs[collabActionMetadata] = _buildDoc(
            collabActionMetadata,
            action: collabAction,
            authorGetter: (_) => collab,
          );
        }
      }
    }

    _cachePopulateCompleter.complete(true);
  }
}

extension on SignedDocumentMetadataRef {
  ReferenceUuid get asCose => ReferenceUuid(
    id: id.asCose,
    ver: ver?.asCose,
  );

  DocumentRefForFilteredDocuments get asIndex {
    return DocumentRefForFilteredDocuments(id: id, ver: ver);
  }
}

extension on String {
  Uuid get asCose => Uuid(this);
}

extension on SignedDocumentMetadata {
  IndividualDocumentVersion get asIndex {
    return IndividualDocumentVersion(
      ver: ver!,
      type: documentType.uuid,
      ref: ref?.asIndex,
      reply: reply?.asIndex,
      template: template?.asIndex,
      category: categoryId?.asIndex,
      parameters: categoryId?.asIndex,
    );
  }
}

extension on List<SignedDocumentMetadata> {
  DocumentIndexListDto asIndex(String id) {
    return DocumentIndexListDto(
      id: id,
      ver: map((e) => e.asIndex).toList(),
    );
  }
}

extension on SignedDocumentRef {
  SignedDocumentMetadataRef get asMetadataRef {
    return SignedDocumentMetadataRef(id: id, ver: ver);
  }
}
