import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Describes what [DocumentDataContent] is about. It only makes sens in
/// context of [type].
final class DocumentDataMetadata extends Equatable {
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

  /// A list of referenced parameters like brand, category or campaign.
  final List<SignedDocumentRef> parameters;

  /// List of authors represented by CatalystId
  final List<CatalystId>? authors;

  // TODO(damian-molinski): refactor with factory constructors for
  // proposal/comment to centralize required fields for each type.
  DocumentDataMetadata({
    required this.type,
    required this.selfRef,
    this.ref,
    this.template,
    this.reply,
    this.section,
    this.parameters = const [],
    this.authors,
  }) : assert(
         selfRef.isExact,
         'selfRef have to be exact. Make sure version is not null',
       );

  String get id => selfRef.id;

  @override
  List<Object?> get props => [
    type,
    selfRef,
    ref,
    template,
    reply,
    section,
    parameters,
    authors,
  ];

  String get version => selfRef.version!;

  DocumentDataMetadata copyWith({
    DocumentType? type,
    DocumentRef? selfRef,
    Optional<DocumentRef>? ref,
    Optional<SignedDocumentRef>? template,
    Optional<SignedDocumentRef>? reply,
    Optional<String>? section,
    List<SignedDocumentRef>? parameters,
    Optional<List<CatalystId>>? authors,
  }) {
    return DocumentDataMetadata(
      type: type ?? this.type,
      selfRef: selfRef ?? this.selfRef,
      ref: ref.dataOr(this.ref),
      template: template.dataOr(this.template),
      reply: reply.dataOr(this.reply),
      section: section.dataOr(this.section),
      parameters: parameters ?? this.parameters,
      authors: authors.dataOr(this.authors),
    );
  }
}
