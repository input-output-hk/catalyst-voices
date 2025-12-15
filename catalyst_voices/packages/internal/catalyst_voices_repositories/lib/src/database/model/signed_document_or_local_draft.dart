import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/local_documents_drafts.drift.dart';
import 'package:catalyst_voices_repositories/src/database/view/document_metadata_view.drift.dart';
import 'package:equatable/equatable.dart';

/// A sealed class that represents either a signed document that has been
/// submitted or a local draft of a document that has not yet been submitted.
/// This allows for a unified handling of documents in different states within the application.
sealed class SignedDocumentOrLocalDraft extends Equatable {
  /// Creates a const [SignedDocumentOrLocalDraft].
  const SignedDocumentOrLocalDraft();

  /// A factory constructor for creating a [SignedDocumentOrLocalDraft] that represents a local draft.
  /// The [data] parameter contains the [LocalDocumentDraftEntity].
  const factory SignedDocumentOrLocalDraft.local(LocalDocumentDraftEntity data) = _LocalDraft;

  /// A factory constructor for creating a [SignedDocumentOrLocalDraft] that represents a signed document.
  /// The [data] parameter contains the [DocumentEntityV2].
  const factory SignedDocumentOrLocalDraft.signed(DocumentEntityV2 data) = _SignedDocument;

  List<CatalystId> get authors;

  List<CatalystId> get collaborators;

  DocumentDataContent get content;

  String get id;

  DocumentParameters get parameters;

  String? get replyId;

  String? get replyVer;

  String? get templateId;

  String? get templateVer;

  DocumentType get type;

  String get ver;

  DocumentData toModel();
}

final class _LocalDraft extends SignedDocumentOrLocalDraft {
  final LocalDocumentDraftEntity data;

  const _LocalDraft(this.data);

  @override
  List<CatalystId> get authors => data.authors;

  @override
  List<CatalystId> get collaborators => data.collaborators;

  @override
  DocumentDataContent get content => data.content;

  @override
  String get id => data.id;

  @override
  DocumentParameters get parameters => data.parameters;

  @override
  List<Object?> get props => [data];

  @override
  String? get replyId => data.replyId;

  @override
  String? get replyVer => data.replyVer;

  @override
  String? get templateId => data.templateId;

  @override
  String? get templateVer => data.templateVer;

  @override
  DocumentType get type => data.type;

  @override
  String get ver => data.ver;

  @override
  DocumentData toModel() => data.toModel();
}

final class _SignedDocument extends SignedDocumentOrLocalDraft {
  final DocumentEntityV2 data;

  const _SignedDocument(this.data);

  @override
  List<CatalystId> get authors => data.authors;

  @override
  List<CatalystId> get collaborators => data.collaborators;

  @override
  DocumentDataContent get content => data.content;

  @override
  String get id => data.id;

  @override
  DocumentParameters get parameters => data.parameters;

  @override
  List<Object?> get props => [data];

  @override
  String? get replyId => data.replyId;

  @override
  String? get replyVer => data.replyVer;

  @override
  String? get templateId => data.templateId;

  @override
  String? get templateVer => data.templateVer;

  @override
  DocumentType get type => data.type;

  @override
  String get ver => data.ver;

  @override
  DocumentData toModel() => data.toModel();
}

extension on String? {
  SignedDocumentRef? toRef([String? ver]) {
    final id = this;
    if (id == null) {
      return null;
    }

    return SignedDocumentRef(id: id, ver: ver);
  }
}

extension DocumentEntityV2Mapper on DocumentEntityV2 {
  DocumentData toModel() {
    return DocumentData(
      metadata: DocumentDataMetadata(
        contentType: DocumentContentType.fromJson(contentType),
        type: type,
        id: SignedDocumentRef(id: id, ver: ver),
        ref: refId.toRef(refVer),
        template: templateId.toRef(templateVer),
        reply: replyId.toRef(replyVer),
        section: section,
        collaborators: collaborators.isEmpty ? null : collaborators,
        parameters: parameters,
        authors: authors.isEmpty ? null : authors,
      ),
      content: content,
    );
  }
}

extension DocumentsV2MetadataViewDataMapper on DocumentsV2MetadataViewData {
  DocumentDataMetadata toModel() {
    return DocumentDataMetadata(
      contentType: DocumentContentType.fromJson(contentType),
      type: type,
      id: SignedDocumentRef(id: id, ver: ver),
      ref: refId.toRef(refVer),
      template: templateId.toRef(templateVer),
      reply: replyId.toRef(replyVer),
      section: section,
      collaborators: collaborators.isEmpty ? null : collaborators,
      parameters: parameters,
      authors: authors.isEmpty ? null : authors,
    );
  }
}

extension LocalDocumentDraftEntityMapper on LocalDocumentDraftEntity {
  DocumentData toModel() {
    return DocumentData(
      metadata: DocumentDataMetadata(
        contentType: DocumentContentType.fromJson(contentType),
        type: type,
        id: DraftRef(id: id, ver: ver),
        ref: refId.toRef(refVer),
        template: templateId.toRef(templateVer),
        reply: replyId.toRef(replyVer),
        section: section,
        collaborators: collaborators.isEmpty ? null : collaborators,
        parameters: parameters,
        authors: authors.isEmpty ? null : authors,
      ),
      content: content,
    );
  }
}

extension LocalDocumentsDraftsMetadataViewDataMapper on LocalDocumentsDraftsMetadataViewData {
  DocumentDataMetadata toModel() {
    return DocumentDataMetadata(
      contentType: DocumentContentType.fromJson(contentType),
      type: type,
      id: DraftRef(id: id, ver: ver),
      ref: refId.toRef(refVer),
      template: templateId.toRef(templateVer),
      reply: replyId.toRef(replyVer),
      section: section,
      collaborators: collaborators.isEmpty ? null : collaborators,
      parameters: parameters,
      authors: authors.isEmpty ? null : authors,
    );
  }
}
