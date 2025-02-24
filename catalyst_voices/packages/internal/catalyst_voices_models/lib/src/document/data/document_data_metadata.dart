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

  DocumentDataMetadata({
    required this.type,
    required this.selfRef,
    this.ref,
    this.refHash,
    this.template,
    this.brandId,
    this.campaignId,
    this.electionId,
    this.categoryId,
  }) : assert(
          selfRef.isExact,
          'selfRef have to be exact. Make sure version is not null',
        );

  String get id => selfRef.id;

  String get version => selfRef.version!;

  @override
  List<Object?> get props => [
        type,
        selfRef,
        ref,
        refHash,
        template,
        brandId,
        campaignId,
        electionId,
        categoryId,
      ];
}
