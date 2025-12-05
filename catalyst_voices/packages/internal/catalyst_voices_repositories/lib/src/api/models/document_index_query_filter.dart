import 'package:catalyst_voices_repositories/src/api/models/id_and_ver_ref.dart';
import 'package:catalyst_voices_repositories/src/api/models/id_selector.dart';
import 'package:catalyst_voices_repositories/src/api/models/ver_selector.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_index_query_filter.g.dart';

/// Query Filter for the generation of a signed document index.
///
/// The Query works as a filter which acts like a sieve to filter out documents
/// which do not strictly match the metadata or payload fields included in the query
/// itself.
///
/// Used as request body for POST /api/v2/document/index
@JsonSerializable(createFactory: false, includeIfNull: false)
final class DocumentIndexQueryFilter {
  /// ## Signed Document Type.
  ///
  /// The document type must match one of the
  /// [Registered Document Types](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/types/)
  ///
  /// UUIDv4 Formatted 128bit value.
  ///
  /// Max 10 items.
  final List<String>? type;

  /// ## Document ID
  ///
  /// Either an absolute single Document ID or a range of
  /// [Document IDs](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#id)
  final IdSelector? id;

  /// ## Document Version
  ///
  /// Either an absolute single Document Version or a range of
  /// [Document Versions](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#ver)
  final VerSelector? ver;

  /// ## Document Reference
  ///
  /// A [reference](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#ref)
  /// to another signed document.  This fields can match any reference that matches the
  /// defined [Document IDs](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#id)
  /// and/or
  /// [Document Versions](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#ver)
  ///
  /// The kind of document that the reference refers to is defined by the
  /// [Document Type](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/types/)
  final IdAndVerRef? ref;

  /// ## Document Template
  ///
  /// Documents that are created based on a template include the
  /// [template reference](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#template)
  /// to another signed document.  This fields can match any template reference that
  /// matches the defined [Document IDs](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#id)
  /// and/or
  /// [Document Versions](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#ver)
  ///
  /// The kind of document that the reference refers to is defined by the
  /// [Document Type](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/types/)
  /// however, it will always be a template type document that matches the document
  /// itself.
  final IdAndVerRef? template;

  /// ## Document Reply
  ///
  /// This is a
  /// [reply reference](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#reply)
  /// which links one document to another, when acting as a reply to it.
  /// Replies typically reference the same kind of document.
  /// This fields can match any reply reference that matches the defined
  /// [Document IDs](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#id)
  /// and/or
  /// [Document Versions](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#ver)
  ///
  /// The kind of document that the reference refers to is defined by the
  /// [Document Type](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/types/).
  final IdAndVerRef? reply;

  /// ## Document Parameters
  ///
  /// This is a
  /// [parameters reference](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#parameters).
  /// Reference to a configuration document.
  /// This fields can match any reference that matches the defined
  /// [Document IDs](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#id)
  /// and/or
  /// [Document Versions](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#ver)
  ///
  /// Whether a Document Type has a brand, campaign, category etc. reference is defined
  /// by its [Document Type](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/types/).
  @JsonKey(name: 'doc_parameters')
  final IdAndVerRef? parameters;

  const DocumentIndexQueryFilter({
    this.type,
    this.id,
    this.ver,
    this.ref,
    this.template,
    this.reply,
    this.parameters,
  });

  Map<String, dynamic> toJson() => _$DocumentIndexQueryFilterToJson(this);
}
