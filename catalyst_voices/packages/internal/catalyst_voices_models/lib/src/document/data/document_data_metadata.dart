import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Describes what [DocumentDataContent] is about. It only makes sense in
/// the context of [type].
final class DocumentDataMetadata extends Equatable {
  /// The content type of the document payload this metadata is attached to.
  final DocumentContentType contentType;

  /// Type of this signed document
  final DocumentType type;

  /// Reference to this document. Have to be exact.
  final DocumentRef selfRef;

  /// Reference to another document. The purpose of the ref will vary depending
  /// on the document type.
  final DocumentRef? ref;

  /// If the document was formed from a template, this is a reference to that
  /// template document
  final SignedDocumentRef? template;

  /// A reply to another document.
  final SignedDocumentRef? reply;

  /// A reference to a section of a document.
  final String? section;

  /// A list of allowed Collaborators on the next subsequent version of a document.
  final List<CatalystId>? collaborators;

  /// A list of referenced parameters like brand, category or campaign.
  final DocumentParameters parameters;

  /// List of authors represented by CatalystId.
  ///
  /// Note. This list just represents who signed this version
  /// Note. Can change from version to version when [collaborators] are non empty.
  final List<CatalystId>? authors;

  /// The default constructor for the [DocumentDataMetadata].
  DocumentDataMetadata({
    required this.contentType,
    required this.type,
    required this.selfRef,
    this.ref,
    this.template,
    this.reply,
    this.section,
    this.collaborators,
    this.parameters = const DocumentParameters(),
    this.authors,
  }) : assert(
         selfRef.isExact,
         'selfRef have to be exact. Make sure version is not null',
       );

  /// Creates a [DocumentDataMetadata] representing a [DocumentType.commentDocument].
  ///
  /// The [parameters] should be the ones assigned to the [proposalRef].
  factory DocumentDataMetadata.comment({
    required SignedDocumentRef selfRef,
    required SignedDocumentRef proposalRef,
    required SignedDocumentRef template,
    required DocumentParameters parameters,
    required List<CatalystId> authors,
    SignedDocumentRef? reply,
  }) {
    return DocumentDataMetadata(
      contentType: DocumentContentType.json,
      type: DocumentType.commentDocument,
      selfRef: selfRef,
      ref: proposalRef,
      template: template,
      reply: reply,
      parameters: parameters,
      authors: authors,
    );
  }

  /// Creates a [DocumentDataMetadata] representing a [DocumentType.proposalDocument].
  ///
  /// The [parameters] should be the ones assigned to the [template].
  factory DocumentDataMetadata.proposal({
    required DocumentRef selfRef,
    required SignedDocumentRef template,
    required DocumentParameters parameters,
    required List<CatalystId> authors,
    List<CatalystId>? collaborators,
  }) {
    return DocumentDataMetadata(
      type: DocumentType.proposalDocument,
      contentType: DocumentContentType.json,
      selfRef: selfRef,
      template: template,
      parameters: parameters,
      authors: authors,
      collaborators: collaborators,
    );
  }

  /// Creates a [DocumentDataMetadata] representing a [DocumentType.proposalActionDocument].
  ///
  /// The [parameters] should be the ones assigned to the [proposalRef].
  factory DocumentDataMetadata.proposalAction({
    required SignedDocumentRef selfRef,
    required SignedDocumentRef proposalRef,
    required DocumentParameters parameters,
  }) {
    return DocumentDataMetadata(
      type: DocumentType.proposalActionDocument,
      contentType: DocumentContentType.json,
      selfRef: selfRef,
      ref: proposalRef,
      parameters: parameters,
    );
  }

  /// Creates a [DocumentDataMetadata] representing a [DocumentType.proposalTemplate].
  ///
  /// The [parameters] should be the ones assigned to template's parent, most likely the category.
  factory DocumentDataMetadata.proposalTemplate({
    required DocumentRef selfRef,
    required DocumentParameters parameters,
  }) {
    return DocumentDataMetadata(
      type: DocumentType.proposalTemplate,
      contentType: DocumentContentType.schemaJson,
      selfRef: selfRef,
      parameters: parameters,
    );
  }

  String get id => selfRef.id;

  @override
  List<Object?> get props => [
    contentType,
    type,
    selfRef,
    ref,
    template,
    reply,
    section,
    collaborators,
    parameters,
    authors,
  ];

  /// Who signed this document version. Can change from version to version.
  List<CatalystId>? get signers => authors;

  String get version => selfRef.version!;

  DocumentDataMetadata copyWith({
    DocumentContentType? contentType,
    DocumentType? type,
    DocumentRef? selfRef,
    Optional<DocumentRef>? ref,
    Optional<SignedDocumentRef>? template,
    Optional<SignedDocumentRef>? reply,
    Optional<String>? section,
    Optional<List<CatalystId>>? collaborators,
    DocumentParameters? parameters,
    Optional<List<CatalystId>>? authors,
  }) {
    return DocumentDataMetadata(
      contentType: contentType ?? this.contentType,
      type: type ?? this.type,
      selfRef: selfRef ?? this.selfRef,
      ref: ref.dataOr(this.ref),
      template: template.dataOr(this.template),
      reply: reply.dataOr(this.reply),
      section: section.dataOr(this.section),
      collaborators: collaborators.dataOr(this.collaborators),
      parameters: parameters ?? this.parameters,
      authors: authors.dataOr(this.authors),
    );
  }
}
