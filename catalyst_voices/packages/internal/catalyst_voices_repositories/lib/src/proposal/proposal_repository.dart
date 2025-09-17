import 'dart:convert';
import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/document/source/proposal_document_data_local_source.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/proposal/proposal_submission_action_dto.dart';
import 'package:rxdart/rxdart.dart';

/// Base interface to interact with proposals. A specialized version of [DocumentRepository] which
/// provides additional methods specific to proposals.
abstract interface class ProposalRepository {
  const factory ProposalRepository(
    SignedDocumentManager signedDocumentManager,
    DocumentRepository documentRepository,
    ProposalDocumentDataLocalSource proposalsLocalSource,
  ) = ProposalRepositoryImpl;

  Future<void> deleteDraftProposal(DraftRef ref);

  Future<Uint8List> encodeProposalForExport({
    required DocumentData document,
  });

  Future<ProposalData> getProposal({
    required DocumentRef ref,
  });

  Future<ProposalPublish?> getProposalPublishForRef({
    required DocumentRef ref,
  });

  Future<List<ProposalData>> getProposals({
    SignedDocumentRef? categoryRef,
    required ProposalsFilterType type,
  });

  /// Fetches all proposals for page matching [request] as well as
  /// [filters].
  Future<Page<ProposalData>> getProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
    required ProposalsOrder order,
  });

  /// Returns [ProposalTemplate] for matching [ref].
  ///
  /// Source of data depends whether [ref] is [SignedDocumentRef] or [DraftRef].
  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef ref,
  });

  Future<DocumentRef> importProposal(Uint8List data, CatalystId authorId);

  Future<void> publishProposal({
    required DocumentData document,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  });

  Future<void> publishProposalAction({
    required SignedDocumentRef actionRef,
    required SignedDocumentRef proposalRef,
    required SignedDocumentRef categoryId,
    required ProposalSubmissionAction action,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  });

  Future<List<ProposalDocument>> queryVersionsOfId({
    required String id,
    bool includeLocalDrafts = false,
  });

  Future<void> upsertDraftProposal({required DocumentData document});

  Stream<int> watchCommentsCount({
    DocumentRef? refTo,
  });

  Stream<List<ProposalDocument>> watchLatestProposals({int? limit});

  /// Watches for [ProposalSubmissionAction] that were made on [refTo] document.
  ///
  /// As making action on document not always creates a new document ref
  /// we need to watch for actions on a document that has a reference to
  /// [refTo] document.
  Stream<ProposalPublish?> watchProposalPublish({
    required DocumentRef refTo,
  });

  Stream<ProposalsCount> watchProposalsCount({
    required ProposalsCountFilters filters,
  });

  Stream<Page<ProposalData>> watchProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
    required ProposalsOrder order,
  });

  Stream<List<ProposalDocument>> watchUserProposals({
    required CatalystId authorId,
  });
}

final class ProposalRepositoryImpl implements ProposalRepository {
  final SignedDocumentManager _signedDocumentManager;
  final DocumentRepository _documentRepository;
  final ProposalDocumentDataLocalSource _proposalsLocalSource;

  const ProposalRepositoryImpl(
    this._signedDocumentManager,
    this._documentRepository,
    this._proposalsLocalSource,
  );

  @override
  Future<void> deleteDraftProposal(DraftRef ref) {
    return _documentRepository.deleteDocumentDraft(ref: ref);
  }

  @override
  Future<Uint8List> encodeProposalForExport({
    required DocumentData document,
  }) {
    return _documentRepository.encodeDocumentForExport(
      document: document,
    );
  }

  @override
  Future<ProposalData> getProposal({
    required DocumentRef ref,
  }) async {
    final documentData = await _documentRepository.getDocumentData(ref: ref);
    final commentsCount = await _documentRepository.getRefCount(
      ref: ref,
      type: DocumentType.commentDocument,
    );
    final proposalPublish = await getProposalPublishForRef(ref: ref);
    if (proposalPublish == null) {
      throw const NotFoundException(message: 'Proposal is hidden');
    }
    final templateRef = documentData.metadata.template!;
    final documentTemplate = await _documentRepository.getDocumentData(ref: templateRef);
    final proposalDocument = _buildProposalDocument(
      documentData: documentData,
      templateData: documentTemplate,
    );

    return ProposalData(
      document: proposalDocument,
      commentsCount: commentsCount,
      publish: proposalPublish,
    );
  }

  @override
  Future<ProposalPublish?> getProposalPublishForRef({
    required DocumentRef ref,
  }) async {
    final data = await _documentRepository.getRefToDocumentData(
      refTo: ref,
      type: DocumentType.proposalActionDocument,
    );

    final action = _buildProposalActionData(data);
    return _getProposalPublish(ref: ref, action: action);
  }

  @override
  Future<List<ProposalData>> getProposals({
    SignedDocumentRef? categoryRef,
    required ProposalsFilterType type,
  }) async {
    return _proposalsLocalSource
        .getProposals(type: type, categoryRef: categoryRef)
        .then((value) => value.map(_buildProposalData).toList());
  }

  @override
  Future<Page<ProposalData>> getProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
    required ProposalsOrder order,
  }) {
    return _proposalsLocalSource
        .getProposalsPage(request: request, filters: filters, order: order)
        .then((value) => value.map(_buildProposalData));
  }

  @override
  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef ref,
  }) async {
    final proposalDocument = await _documentRepository.getDocumentData(ref: ref);

    return _buildProposalTemplate(documentData: proposalDocument);
  }

  @override
  Future<DocumentRef> importProposal(Uint8List data, CatalystId authorId) {
    return _documentRepository.importDocument(data: data, authorId: authorId);
  }

  @override
  Future<void> publishProposal({
    required DocumentData document,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  }) async {
    final signedDocument = await _signedDocumentManager.signDocument(
      SignedDocumentJsonPayload(document.content.data),
      metadata: _createProposalMetadata(document.metadata),
      catalystId: catalystId,
      privateKey: privateKey,
    );

    await _documentRepository.publishDocument(document: signedDocument);
  }

  @override
  Future<void> publishProposalAction({
    required SignedDocumentRef actionRef,
    required SignedDocumentRef proposalRef,
    required SignedDocumentRef categoryId,
    required ProposalSubmissionAction action,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  }) async {
    final dto = ProposalSubmissionActionDocumentDto(
      action: ProposalSubmissionActionDto.fromModel(action),
    );
    final signedDocument = await _signedDocumentManager.signDocument(
      SignedDocumentJsonPayload(dto.toJson()),
      metadata: SignedDocumentMetadata(
        contentType: SignedDocumentContentType.json,
        documentType: DocumentType.proposalActionDocument,
        id: actionRef.id,
        ver: actionRef.version,
        ref: SignedDocumentMetadataRef.fromDocumentRef(proposalRef),
        categoryId: SignedDocumentMetadataRef.fromDocumentRef(categoryId),
      ),
      catalystId: catalystId,
      privateKey: privateKey,
    );

    await _documentRepository.publishDocument(document: signedDocument);
  }

  @override
  Future<List<ProposalDocument>> queryVersionsOfId({
    required String id,
    bool includeLocalDrafts = false,
  }) async {
    final documents = await _documentRepository.queryVersionsOfId(
      id: id,
      includeLocalDrafts: includeLocalDrafts,
    );

    return documents
        .map(
          (e) => _buildProposalDocument(
            documentData: e.data,
            templateData: e.refData,
          ),
        )
        .toList();
  }

  @override
  Future<void> upsertDraftProposal({required DocumentData document}) {
    return _documentRepository.upsertDocument(document: document);
  }

  @override
  Stream<int> watchCommentsCount({
    DocumentRef? refTo,
  }) {
    return _documentRepository.watchCount(
      refTo: refTo,
      type: DocumentType.commentDocument,
    );
  }

  @override
  Stream<List<ProposalDocument>> watchLatestProposals({int? limit}) {
    return _documentRepository
        .watchDocuments(
          limit: limit,
          unique: true,
          type: DocumentType.proposalDocument,
        )
        .map(
          (documents) => documents.map(
            (doc) {
              final documentData = doc.data;
              final templateData = doc.refData;

              return _buildProposalDocument(
                documentData: documentData,
                templateData: templateData,
              );
            },
          ).toList(),
        );
  }

  @override
  Stream<ProposalPublish?> watchProposalPublish({
    required DocumentRef refTo,
  }) {
    return _documentRepository
        .watchRefToDocumentData(
          refTo: refTo,
          type: DocumentType.proposalActionDocument,
        )
        .map((data) {
          final action = _buildProposalActionData(data);

          return _getProposalPublish(ref: refTo, action: action);
        });
  }

  @override
  Stream<ProposalsCount> watchProposalsCount({
    required ProposalsCountFilters filters,
  }) {
    return _proposalsLocalSource.watchProposalsCount(filters: filters);
  }

  @override
  Stream<Page<ProposalData>> watchProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
    required ProposalsOrder order,
  }) {
    return _proposalsLocalSource
        .watchProposalsPage(request: request, filters: filters, order: order)
        .map((value) => value.map(_buildProposalData));
  }

  @override
  Stream<List<ProposalDocument>> watchUserProposals({
    required CatalystId authorId,
  }) {
    return _documentRepository
        .watchDocuments(
          type: DocumentType.proposalDocument,
          getLocalDrafts: true,
          unique: true,
          authorId: authorId,
        )
        .whereNotNull()
        .map(
          (documents) => documents.map(
            (doc) {
              final documentData = doc.data;
              final templateData = doc.refData;

              return _buildProposalDocument(
                documentData: documentData,
                templateData: templateData,
              );
            },
          ).toList(),
        );
  }

  ProposalSubmissionAction? _buildProposalActionData(
    DocumentData? action,
  ) {
    if (action == null) {
      return null;
    }
    final dto = ProposalSubmissionActionDocumentDto.fromJson(action.content.data);
    return dto.action.toModel();
  }

  ProposalData _buildProposalData(ProposalDocumentData data) {
    final action = _buildProposalActionData(data.action);

    final publish = switch (action) {
      ProposalSubmissionAction.aFinal => ProposalPublish.submittedProposal,
      ProposalSubmissionAction.draft || null => ProposalPublish.publishedDraft,
      ProposalSubmissionAction.hide => throw ArgumentError(
        'Proposal(${data.proposal.metadata.selfRef}) is '
        'unsupported ${ProposalSubmissionAction.hide}. Make sure to filter '
        'out hidden proposals before this code is reached.',
      ),
    };

    final document = _buildProposalDocument(
      documentData: data.proposal,
      templateData: data.template,
    );

    return ProposalData(
      document: document,
      publish: publish,
      commentsCount: data.commentsCount,
    );
  }

  ProposalDocument _buildProposalDocument({
    required DocumentData documentData,
    required DocumentData templateData,
  }) {
    assert(
      documentData.metadata.type == DocumentType.proposalDocument,
      'Not a proposalDocument document data type',
    );

    final template = _buildProposalTemplate(documentData: templateData);

    final metadata = ProposalMetadata(
      selfRef: documentData.metadata.selfRef,
      templateRef: documentData.metadata.template!,
      categoryId: documentData.metadata.categoryId!,
      authors: documentData.metadata.authors ?? [],
    );

    final content = DocumentDataContentDto.fromModel(
      documentData.content,
    );
    final schema = template.schema;
    final document = DocumentDto.fromJsonSchema(content, schema).toModel();

    return ProposalDocument(
      metadata: metadata,
      document: document,
    );
  }

  ProposalTemplate _buildProposalTemplate({
    required DocumentData documentData,
  }) {
    assert(
      documentData.metadata.type == DocumentType.proposalTemplate,
      'Not a proposalTemplate document data type',
    );

    final metadata = ProposalTemplateMetadata(
      selfRef: documentData.metadata.selfRef,
    );

    final contentData =
        r'''
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://raw.githubusercontent.com/input-output-hk/catalyst-voices/refs/heads/main/docs/src/architecture/08_concepts/document_templates/proposal/F14-Generic/test-minimal.schema.json",
  "title": "F-X Renderer Verification Template",
  "description": "Schema designed to verify renderer dynamic ability",
  "maintainers": [{ "name": "Catalyst Team", "url": "https://projectcatalyst.io/" }],
  "type": "object",
  "additionalProperties": false,
  "definitions": {
    "schemaReferenceNonUI": {
      "$comment": "NOT UI: used to identify the kind of template document used.",
      "type": "string",
      "format": "path",
      "readOnly": true
    },
    "segment": {
      "$comment": "UI - Logical Document Section Break.",
      "type": "object",
      "additionalProperties": false,
      "properties": {
        "title": { "type": "object" },
        "proposer": { "type": "object" },
        "budget": { "type": "object" },
        "solution": { "type": "object" }
      },
      "x-note": "Major sections of the proposal. Each segment contains sections of information grouped together."
    },
    "section": {
      "$comment": "UI - Logical Document Sub-Section Break.",
      "type": "object",
      "additionalProperties": false,
      "x-note": "Subsections containing specific details about the proposal."
    },
    "singleLineTextEntry": {
      "$comment": "UI - Single Line text entry without any markup or rich text capability.",
      "type": "string",
      "contentMediaType": "text/plain",
      "pattern": "^.*$"
    },
    "multiLineTextEntryMarkdown": {
      "$comment": "UI - Multiline text entry with Markdown content.",
      "type": "string",
      "contentMediaType": "text/markdown",
      "pattern": "^[\\S\\s]*$"
    },
    "radioButtonSelect": {
      "$comment": "UI - Radio Button Selection",
      "type": "string",
      "format": "radioButtonSelect"
    },
    "tokenValueCardanoADA": {
      "$comment": "UI - A Token Value denominated in Cardano ADA.",
      "type": "integer",
      "format": "token:cardano:ada"
    }
  },
  "properties": {
    "$schema": {
      "$ref": "#/definitions/schemaReferenceNonUI",
      "default": "./0ce8ab38-9258-4fbc-a62e-7faa6e58318f.schema.json",
      "const": "./0ce8ab38-9258-4fbc-a62e-7faa6e58318f.schema.json"
    },
    "setup": {
      "$ref": "#/definitions/segment",
      "title": "Section A — Who and What?",
      "description": "Tell us who you are and give your idea a title",
      "properties": {
        "proposer": {
          "$ref": "#/definitions/section",
          "title": "Identity Checkpoint",
          "description": "Who's behind this proposal",
          "properties": {
            "applicant": {
              "$ref": "#/definitions/singleLineTextEntry",
              "title": "Your Name",
              "description": "Enter your full name, nickname, or alias",
              "minLength": 2,
              "maxLength": 100
            },
            "type": {
              "$ref": "#/definitions/radioButtonSelect",
              "title": "Choose which best applies",
              "description": "How are you applying?",
              "enum": [
                "Solo",
                "Group",
                "Company"
              ]
            }
          },
          "required": ["applicant", "type"],
          "x-order": ["applicant", "type"]
        },
        "title": {
          "$ref": "#/definitions/section",
          "title": "Give It a Title",
          "description": "What's the title for your idea?",
          "properties": {
            "title": {
              "$ref": "#/definitions/singleLineTextEntry",
              "title": "Project Banner",
              "description": "Write a short title (max 60 chars)",
              "minLength": 3,
              "maxLength": 60
            }
          },
          "required": ["title"]
        }
      },
      "required": ["proposer", "title"],
      "x-order": ["proposer", "title"]
    },
    "summary": {
      "$ref": "#/definitions/segment",
      "title": "Section B — The Core Idea",
      "description": "Explain the essentials of your project",
      "properties": {
        "solution": {
          "$ref": "#/definitions/section",
          "title": "What's the secret?",
          "description": "Describe your project core purpose",
          "properties": {
            "summary": {
              "$ref": "#/definitions/multiLineTextEntryMarkdown",
              "title": "One-Paragraph Story",
              "description": "Tell us a story about your idea (50–200 chars)",
              "minLength": 50,
              "maxLength": 200
            }
          },
          "required": ["summary"]
        },
        "budget": {
          "$ref": "#/definitions/section",
          "title": "How Much Will It Cost?",
          "description": "Tell us how much ADA you need",
          "properties": {
            "requestedFunds": {
              "$ref": "#/definitions/tokenValueCardanoADA",
              "title": "Requested (ADA)",
              "description": "Enter your desired amount between ₳15k and ₳60k",
              "minimum": 15000,
              "maximum": 60000
            }
          },
          "required": ["requestedFunds"]
        }
      },
      "required": ["solution", "budget"],
      "x-order": ["solution", "budget"]
    }
  },
  "required": ["setup", "summary"],
  "x-order": ["setup", "summary"]
}
'''
            .trim();

    final schema = DocumentSchemaDto.fromJson(
      jsonDecode(contentData) as Map<String, dynamic>,
    ).toModel();

    return ProposalTemplate(
      metadata: metadata,
      schema: schema,
    );
  }

  SignedDocumentMetadata _createProposalMetadata(
    DocumentDataMetadata metadata,
  ) {
    final template = metadata.template;
    final categoryId = metadata.categoryId;

    return SignedDocumentMetadata(
      contentType: SignedDocumentContentType.json,
      documentType: DocumentType.proposalDocument,
      id: metadata.id,
      ver: metadata.version,
      template: template == null ? null : SignedDocumentMetadataRef.fromDocumentRef(template),
      categoryId: categoryId == null ? null : SignedDocumentMetadataRef.fromDocumentRef(categoryId),
    );
  }

  ProposalPublish? _getProposalPublish({
    required DocumentRef ref,
    required ProposalSubmissionAction? action,
  }) {
    if (ref is DraftRef) {
      return ProposalPublish.localDraft;
    } else {
      return switch (action) {
        ProposalSubmissionAction.aFinal => ProposalPublish.submittedProposal,
        ProposalSubmissionAction.hide => null,
        ProposalSubmissionAction.draft || null => ProposalPublish.publishedDraft,
      };
    }
  }
}
