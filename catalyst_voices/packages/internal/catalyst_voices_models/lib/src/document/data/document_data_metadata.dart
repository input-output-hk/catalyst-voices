import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Base class with common functionality
abstract class BaseDocumentDataMetadata extends Equatable {
  /// Type of this signed document
  final DocumentType type;

  /// Reference to another document. The purpose of the ref will vary depending
  /// on the document type.
  final DocumentRef? ref;

  /// This is a cryptographically secured reference to another document.
  final SecuredDocumentRef? refHash;

  /// If the document was formed from a template, this is a reference to that
  /// template document
  final DocumentRef? template;

  /// uuid-v4
  /// Represents a "brand" who is running the voting, e.g. Catalyst, Midnight.
  final String? brandId;

  /// uuid-v4
  /// Defines a "campaign" of voting, e.g. "treasury campaign".
  final String? campaignId;

  /// uuid-v4
  /// Defines an election, e.g. "Catalyst Fund 1", "Catalyst Fund 2".
  final String? electionId;

  /// uuid-v4
  /// Defines a voting category as a collection of proposals, e.g.
  /// "Development & Infrastructure",
  /// "Products & Integrations".
  final String? categoryId;

  const BaseDocumentDataMetadata({
    required this.type,
    this.ref,
    this.refHash,
    this.template,
    this.brandId,
    this.campaignId,
    this.electionId,
    this.categoryId,
  });

  @override
  List<Object?> get props => [
        type,
        ref,
        refHash,
        template,
        brandId,
        campaignId,
        electionId,
        categoryId,
      ];
}

final class DocumentDataMetadata extends BaseDocumentDataMetadata {
  /// Reference to this document. Have to be exact.
  final DocumentRef selfRef;

  DocumentDataMetadata({
    required super.type,
    required this.selfRef,
    super.ref,
    super.refHash,
    super.template,
    super.brandId,
    super.campaignId,
    super.electionId,
    super.categoryId,
  }) : assert(
          selfRef.isExact,
          'selfRef have to be exact. Make sure version is not null',
        );

  String get id => selfRef.id;
  @override
  List<Object?> get props => [...super.props, selfRef];

  String get version => selfRef.version!;
}

final class DocumentDataMetadataOptional extends BaseDocumentDataMetadata {
  /// Reference to this document. Can be null.
  final DocumentRef? selfRef;

  const DocumentDataMetadataOptional({
    required super.type,
    this.selfRef,
    super.ref,
    super.refHash,
    super.template,
    super.brandId,
    super.campaignId,
    super.electionId,
    super.categoryId,
  });

  String? get id => selfRef?.id;
  @override
  List<Object?> get props => [...super.props, selfRef];

  String? get version => selfRef?.version;
}
