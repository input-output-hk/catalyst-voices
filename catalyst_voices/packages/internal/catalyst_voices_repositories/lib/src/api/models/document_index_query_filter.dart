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
  /// [Registered Document Types](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/types/)
  ///
  /// UUIDv4 Formatted 128bit value.
  ///
  /// Max items 10
  final List<String>? type;

  /// Document ID Selector
  ///
  /// Either a absolute single Document ID or a range of Document IDs
  final IdSelector? id;

  /// Document Version Selector
  ///
  /// Either a absolute single Document Version or a range of Document Versions
  final VerSelector? ver;

  /// ## Document Reference
  ///
  /// A [reference](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/meta/#ref-document-reference)
  /// to another signed document.  This fields can match any reference that matches the
  /// defined [Document IDs](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id)
  /// and/or
  /// [Document Versions](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#ver)
  ///
  /// The kind of document that the reference refers to is defined by the
  /// [Document Type](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/types/)
  ///
  /// Max items 10
  final List<IdAndVerRef>? ref;

  /// ## Document Template
  ///
  /// Documents that are created based on a template include the
  /// [template reference](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/meta/#template-template-reference)
  /// to another signed document.  This fields can match any template reference that
  /// matches the defined [Document IDs](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id)
  /// and/or
  /// [Document Versions](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#ver)
  ///
  /// The kind of document that the reference refers to is defined by the
  /// [Document Type](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/types/)
  /// however, it will always be a template type document that matches the document
  /// itself.
  ///
  /// Max items 10
  final List<IdAndVerRef>? template;

  /// ## Document Reply
  ///
  /// This is a
  /// [reply reference](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/meta/#reply-reply-reference)
  /// which links one document to another, when acting as a reply to it.
  /// Replies typically reference the same kind of document.
  /// This fields can match any reply reference that matches the defined
  /// [Document IDs](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id)
  /// and/or
  /// [Document Versions](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#ver)
  ///
  /// The kind of document that the reference refers to is defined by the
  /// [Document Type](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/types/).
  ///
  /// Max items 10
  final List<IdAndVerRef>? reply;

  /// ## Brand
  ///
  /// This is a
  /// [brand reference](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/meta/#brand_id)
  /// to a brand document which defines the brand the document falls under.
  /// This fields can match any brand reference that matches the defined
  /// [Document IDs](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id)
  /// and/or
  /// [Document Versions](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#ver)
  ///
  /// Whether a Document Type has a brand reference is defined by its
  /// [Document Type](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/types/).
  ///
  /// Max items 10
  final List<IdAndVerRef>? brand;

  /// ## Campaign
  ///
  /// This is a
  /// [campaign reference](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/meta/#campaign_id)
  /// to a campaign document which defines the campaign the document falls under.
  /// This fields can match any campaign reference that matches the defined
  /// [Document IDs](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id)
  /// and/or
  /// [Document Versions](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#ver)
  ///
  /// Whether a Document Type has a campaign reference is defined by its
  /// [Document Type](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/types/).
  ///
  /// Max items 10
  final List<IdAndVerRef>? campaign;

  /// ## Category
  ///
  /// This is a
  /// [category reference](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/meta/#category_id)
  /// to a category document which defines the category the document falls under.
  /// This fields can match any category reference that matches the defined
  /// [Document IDs](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id)
  /// and/or
  /// [Document Versions](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#ver)
  ///
  /// Whether a Document Type has a category reference is defined by its
  /// [Document Type](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/types/).
  ///
  /// Max items 10
  final List<IdAndVerRef>? category;

  const DocumentIndexQueryFilter({
    this.type,
    this.id,
    this.ver,
    this.ref,
    this.template,
    this.reply,
    this.brand,
    this.campaign,
    this.category,
  });

  Map<String, dynamic> toJson() => _$DocumentIndexQueryFilterToJson(this);
}
