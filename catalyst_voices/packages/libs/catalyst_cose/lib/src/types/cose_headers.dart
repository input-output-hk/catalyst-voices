import 'dart:typed_data';

import 'package:catalyst_cose/src/cose_constants.dart';
import 'package:catalyst_cose/src/types/cose_document_ref.dart';
import 'package:catalyst_cose/src/types/cose_string_or_int.dart';
import 'package:catalyst_cose/src/types/cose_uuid.dart';
import 'package:catalyst_cose/src/utils/cbor_utils.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

/// A callback to get an optional value.
/// Helps to distinguish whether a method argument
/// has been passed as null or not passed at all.
///
/// See [CoseHeaders.copyWith].
typedef OptionalValueGetter<T> = T? Function();

/// A class that specifies headers that
/// can be used in protected/unprotected COSE headers.
final class CoseHeaders extends Equatable {
  /// See [CoseHeaderKeys.alg].
  ///
  /// Do not set the [alg] directly in the headers,
  /// it will be auto-populated with [CatalystCoseSigner.alg] value.
  final CoseStringOrInt? alg;

  /// See [CoseHeaderKeys.kid].
  ///
  /// Do not set the [kid] directly in the headers,
  /// it will be auto-populated with [CatalystCoseSigner.kid] value.
  final Uint8List? kid;

  /// See [CoseHeaderKeys.contentType].
  final CoseStringOrInt? contentType;

  /// See [CoseHeaderKeys.contentEncoding].
  final CoseStringOrInt? contentEncoding;

  /// See [CoseHeaderKeys.type].
  final CoseUuid? type;

  /// See [CoseHeaderKeys.id].
  final CoseUuid? id;

  /// See [CoseHeaderKeys.ver].
  final CoseUuid? ver;

  /// See [CoseHeaderKeys.ref].
  final CoseDocumentRefs? ref;

  /// See [CoseHeaderKeys.template].
  final CoseDocumentRefs? template;

  /// See [CoseHeaderKeys.reply].
  final CoseDocumentRefs? reply;

  /// See [CoseHeaderKeys.section].
  final String? section;

  /// See [CoseHeaderKeys.collaborators].
  ///
  /// In previous versions of the spec the field was under [CoseHeaderKeys.collabs] key.
  final List<String>? collaborators;

  /// See [CoseHeaderKeys.brandId].
  final CoseReferenceUuid? brandId;

  /// See [CoseHeaderKeys.campaignId].
  final CoseReferenceUuid? campaignId;

  /// See [CoseHeaderKeys.electionId].
  final String? electionId;

  /// See [CoseHeaderKeys.categoryId].
  final CoseReferenceUuid? categoryId;

  /// Whether the type should be wrapped in extra [CborBytes]
  /// or be a plain [CborMap], both formats are supported.
  ///
  /// For protected headers this should be `true`
  /// while for unprotected headers it should be `false`.
  final bool encodeAsBytes;

  /// The default constructor for the [CoseHeaders].
  const CoseHeaders({
    this.alg,
    this.kid,
    this.contentType,
    this.contentEncoding,
    this.type,
    this.id,
    this.ver,
    this.ref,
    this.template,
    this.reply,
    this.section,
    this.collaborators,
    this.brandId,
    this.campaignId,
    this.electionId,
    this.categoryId,
    required this.encodeAsBytes,
  });

  /// Deserializes the type from cbor.
  factory CoseHeaders.fromCbor(CborValue value, {bool encodeAsBytes = true}) {
    final CborMap map;

    if (value is CborMap) {
      // cose headers per specification might be wrapped in extra CborBytes,
      // both formats are valid
      map = value;
    } else {
      final cborBytes = value as CborBytes;
      final encodedMap = cbor.decode(cborBytes.bytes);
      map = encodedMap as CborMap;
    }

    return CoseHeaders(
      alg: CborUtils.deserializeStringOrInt(map[CoseHeaderKeys.alg]),
      kid: CborUtils.deserializeBytes(map[CoseHeaderKeys.kid]),
      contentType: CborUtils.deserializeStringOrInt(map[CoseHeaderKeys.contentType]),
      contentEncoding: CborUtils.deserializeStringOrInt(map[CoseHeaderKeys.contentEncoding]),
      type: CborUtils.deserializeUuid(map[CoseHeaderKeys.type]),
      id: CborUtils.deserializeUuid(map[CoseHeaderKeys.id]),
      ver: CborUtils.deserializeUuid(map[CoseHeaderKeys.ver]),
      ref: CborUtils.deserializeDocumentRefs(map[CoseHeaderKeys.ref]),
      template: CborUtils.deserializeDocumentRefs(map[CoseHeaderKeys.template]),
      reply: CborUtils.deserializeDocumentRefs(map[CoseHeaderKeys.reply]),
      section: CborUtils.deserializeString(map[CoseHeaderKeys.section]),
      collaborators: CborUtils.deserializeStringList(
        map[CoseHeaderKeys.collaborators] ?? map[CoseHeaderKeys.collabs],
      ),
      brandId: CborUtils.deserializeReferenceUuid(map[CoseHeaderKeys.brandId]),
      campaignId: CborUtils.deserializeReferenceUuid(map[CoseHeaderKeys.campaignId]),
      electionId: CborUtils.deserializeString(map[CoseHeaderKeys.electionId]),
      categoryId: CborUtils.deserializeReferenceUuid(map[CoseHeaderKeys.categoryId]),
      encodeAsBytes: encodeAsBytes,
    );
  }

  /// The constructor for the protected [CoseHeaders].
  const CoseHeaders.protected({
    this.alg,
    this.kid,
    this.contentType,
    this.contentEncoding,
    this.type,
    this.id,
    this.ver,
    this.ref,
    this.template,
    this.reply,
    this.section,
    this.collaborators,
    this.brandId,
    this.campaignId,
    this.electionId,
    this.categoryId,
  }) : encodeAsBytes = true;

  /// The constructor for the unprotected [CoseHeaders].
  const CoseHeaders.unprotected({
    this.alg,
    this.kid,
    this.contentType,
    this.contentEncoding,
    this.type,
    this.id,
    this.ver,
    this.ref,
    this.template,
    this.reply,
    this.section,
    this.collaborators,
    this.brandId,
    this.campaignId,
    this.electionId,
    this.categoryId,
  }) : encodeAsBytes = false;

  @override
  List<Object?> get props => [
    alg,
    kid,
    contentType,
    contentEncoding,
    type,
    id,
    ver,
    ref,
    template,
    reply,
    section,
    collaborators,
    brandId,
    campaignId,
    electionId,
    categoryId,
    encodeAsBytes,
  ];

  /// Returns a copy of the [CoseHeaders] with overwritten properties.
  CoseHeaders copyWith({
    OptionalValueGetter<CoseStringOrInt?>? alg,
    OptionalValueGetter<Uint8List?>? kid,
    OptionalValueGetter<CoseStringOrInt?>? contentType,
    OptionalValueGetter<CoseStringOrInt?>? contentEncoding,
    OptionalValueGetter<CoseUuid?>? type,
    OptionalValueGetter<CoseUuid?>? id,
    OptionalValueGetter<CoseUuid?>? ver,
    OptionalValueGetter<CoseDocumentRefs?>? ref,
    OptionalValueGetter<CoseDocumentRefs?>? template,
    OptionalValueGetter<CoseDocumentRefs?>? reply,
    OptionalValueGetter<String?>? section,
    OptionalValueGetter<List<String>?>? collaborators,
    OptionalValueGetter<CoseReferenceUuid?>? brandId,
    OptionalValueGetter<CoseReferenceUuid?>? campaignId,
    OptionalValueGetter<String?>? electionId,
    OptionalValueGetter<CoseReferenceUuid?>? categoryId,
    bool? encodeAsBytes,
  }) {
    return CoseHeaders(
      alg: alg != null ? alg() : this.alg,
      kid: kid != null ? kid() : this.kid,
      contentType: contentType != null ? contentType() : this.contentType,
      contentEncoding: contentEncoding != null ? contentEncoding() : this.contentEncoding,
      type: type != null ? type() : this.type,
      id: id != null ? id() : this.id,
      ver: ver != null ? ver() : this.ver,
      ref: ref != null ? ref() : this.ref,
      template: template != null ? template() : this.template,
      reply: reply != null ? reply() : this.reply,
      section: section != null ? section() : this.section,
      collaborators: collaborators != null ? collaborators() : this.collaborators,
      brandId: brandId != null ? brandId() : this.brandId,
      campaignId: campaignId != null ? campaignId() : this.campaignId,
      electionId: electionId != null ? electionId() : this.electionId,
      categoryId: categoryId != null ? categoryId() : this.categoryId,
      encodeAsBytes: encodeAsBytes ?? this.encodeAsBytes,
    );
  }

  /// Serializes the type as cbor.
  CborValue toCbor() {
    final map = CborMap({
      if (alg != null) CoseHeaderKeys.alg: alg!.toCbor(),
      if (kid != null) CoseHeaderKeys.kid: CborBytes(kid!),
      if (contentType != null) CoseHeaderKeys.contentType: contentType!.toCbor(),
      if (contentEncoding != null) CoseHeaderKeys.contentEncoding: contentEncoding!.toCbor(),
      if (type != null) CoseHeaderKeys.type: type!.toCbor(),
      if (id != null) CoseHeaderKeys.id: id!.toCbor(),
      if (ver != null) CoseHeaderKeys.ver: ver!.toCbor(),
      if (ref != null) CoseHeaderKeys.ref: ref!.toCbor(),
      if (template != null) CoseHeaderKeys.template: template!.toCbor(),
      if (reply != null) CoseHeaderKeys.reply: reply!.toCbor(),
      if (section != null) CoseHeaderKeys.section: CborString(section!),
      if (brandId != null) CoseHeaderKeys.brandId: brandId!.toCbor(),
      if (campaignId != null) CoseHeaderKeys.campaignId: campaignId!.toCbor(),
      if (electionId != null) CoseHeaderKeys.electionId: CborString(electionId!),
      if (categoryId != null) CoseHeaderKeys.categoryId: categoryId!.toCbor(),
      if (collaborators != null)
        CoseHeaderKeys.collaborators: CborUtils.serializeStringList(collaborators),
    });

    if (encodeAsBytes) {
      return CborBytes(cbor.encode(map));
    } else {
      return map;
    }
  }
}
