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

  /// This is a cryptographically secured reference to another document.
  final SecuredDocumentRef? refHash;

  /// If the document was formed from a template, this is a reference to that
  /// template document
  final SignedDocumentRef? template;

  /// A reply to another document.
  final SignedDocumentRef? reply;

  /// A reference to a section of a document.
  final String? section;

  /// uuid-v4
  /// Represents a "brand" who is running the voting, e.g. Catalyst, Midnight.
  final SignedDocumentRef? brandId;

  /// uuid-v4
  /// Defines a "campaign" of voting, e.g. "treasury campaign".
  final SignedDocumentRef? campaignId;

  /// uuid-v4
  /// Defines an election, e.g. "Catalyst Fund 1", "Catalyst Fund 2".
  final String? electionId;

  /// uuid-v4
  /// Defines a voting category as a collection of proposals, e.g.
  /// "Development & Infrastructure",
  /// "Products & Integrations".
  final SignedDocumentRef? categoryId;

  /// List of authors represented by CatalystId
  final List<CatalystId>? authors;

  DocumentDataMetadata({
    required this.type,
    required this.selfRef,
    this.ref,
    this.refHash,
    this.template,
    this.reply,
    this.section,
    this.brandId,
    this.campaignId,
    this.electionId,
    this.categoryId,
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
        refHash,
        template,
        reply,
        section,
        brandId,
        campaignId,
        electionId,
        categoryId,
        authors,
      ];

  String get version => selfRef.version!;

  DocumentDataMetadata copyWith({
    DocumentType? type,
    DocumentRef? selfRef,
    Optional<DocumentRef>? ref,
    Optional<SecuredDocumentRef>? refHash,
    Optional<SignedDocumentRef>? template,
    Optional<SignedDocumentRef>? reply,
    Optional<String>? section,
    Optional<SignedDocumentRef>? brandId,
    Optional<SignedDocumentRef>? campaignId,
    Optional<String>? electionId,
    Optional<SignedDocumentRef>? categoryId,
    Optional<List<CatalystId>>? authors,
  }) {
    return DocumentDataMetadata(
      type: type ?? this.type,
      selfRef: selfRef ?? this.selfRef,
      ref: ref.dataOr(this.ref),
      refHash: refHash.dataOr(this.refHash),
      template: template.dataOr(this.template),
      reply: reply.dataOr(this.reply),
      section: section.dataOr(this.section),
      brandId: brandId.dataOr(this.brandId),
      campaignId: campaignId.dataOr(this.campaignId),
      electionId: electionId.dataOr(this.electionId),
      categoryId: categoryId.dataOr(this.categoryId),
      authors: authors.dataOr(this.authors),
    );
  }
}
