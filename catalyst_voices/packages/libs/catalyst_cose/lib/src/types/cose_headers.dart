import 'dart:typed_data';

import 'package:catalyst_cose/src/cose_constants.dart';
import 'package:catalyst_cose/src/types/document_type.dart';
import 'package:catalyst_cose/src/types/string_or_int.dart';
import 'package:catalyst_cose/src/types/uuid.dart';
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
  final StringOrInt? alg;

  /// See [CoseHeaderKeys.kid].
  ///
  /// Do not set the [kid] directly in the headers,
  /// it will be auto-populated with [CatalystCoseSigner.kid] value.
  final Uint8List? kid;

  /// See [CoseHeaderKeys.contentType].
  final StringOrInt? contentType;

  /// See [CoseHeaderKeys.contentEncoding].
  final StringOrInt? contentEncoding;

  /// See [CoseHeaderKeys.type].
  final DocumentType? type;

  /// See [CoseHeaderKeys.id].
  final Uuid? id;

  /// See [CoseHeaderKeys.ver].
  final Uuid? ver;

  /// See [CoseHeaderKeys.ref].
  final ReferenceUuid? ref;

  /// See [CoseHeaderKeys.refHash].
  final ReferenceUuidHash? refHash;

  /// See [CoseHeaderKeys.template].
  final ReferenceUuid? template;

  /// See [CoseHeaderKeys.reply].
  final ReferenceUuid? reply;

  /// See [CoseHeaderKeys.section].
  final String? section;

  /// See [CoseHeaderKeys.collabs].
  final List<String>? collabs;

  /// See [CoseHeaderKeys.brandId].
  final ReferenceUuid? brandId;

  /// See [CoseHeaderKeys.campaignId].
  final ReferenceUuid? campaignId;

  /// See [CoseHeaderKeys.electionId].
  final String? electionId;

  /// See [CoseHeaderKeys.categoryId].
  final ReferenceUuid? categoryId;

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
    this.refHash,
    this.template,
    this.reply,
    this.section,
    this.collabs,
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
      type: CborUtils.deserializeDocumentType(map[CoseHeaderKeys.type]),
      id: CborUtils.deserializeUuid(map[CoseHeaderKeys.id]),
      ver: CborUtils.deserializeUuid(map[CoseHeaderKeys.ver]),
      ref: CborUtils.deserializeReferenceUuid(map[CoseHeaderKeys.ref]),
      refHash: CborUtils.deserializeReferenceUuidHash(map[CoseHeaderKeys.refHash]),
      template: CborUtils.deserializeReferenceUuid(map[CoseHeaderKeys.template]),
      reply: CborUtils.deserializeReferenceUuid(map[CoseHeaderKeys.reply]),
      section: CborUtils.deserializeString(map[CoseHeaderKeys.section]),
      collabs: CborUtils.deserializeStringList(map[CoseHeaderKeys.collabs]),
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
    this.refHash,
    this.template,
    this.reply,
    this.section,
    this.collabs,
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
    this.refHash,
    this.template,
    this.reply,
    this.section,
    this.collabs,
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
        refHash,
        template,
        reply,
        section,
        collabs,
        brandId,
        campaignId,
        electionId,
        categoryId,
        encodeAsBytes,
      ];

  /// Returns a copy of the [CoseHeaders] with overwritten properties.
  CoseHeaders copyWith({
    OptionalValueGetter<StringOrInt?>? alg,
    OptionalValueGetter<Uint8List?>? kid,
    OptionalValueGetter<StringOrInt?>? contentType,
    OptionalValueGetter<StringOrInt?>? contentEncoding,
    OptionalValueGetter<DocumentType?>? type,
    OptionalValueGetter<Uuid?>? id,
    OptionalValueGetter<Uuid?>? ver,
    OptionalValueGetter<ReferenceUuid?>? ref,
    OptionalValueGetter<ReferenceUuidHash?>? refHash,
    OptionalValueGetter<ReferenceUuid?>? template,
    OptionalValueGetter<ReferenceUuid?>? reply,
    OptionalValueGetter<String?>? section,
    OptionalValueGetter<List<String>?>? collabs,
    OptionalValueGetter<ReferenceUuid?>? brandId,
    OptionalValueGetter<ReferenceUuid?>? campaignId,
    OptionalValueGetter<String?>? electionId,
    OptionalValueGetter<ReferenceUuid?>? categoryId,
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
      refHash: refHash != null ? refHash() : this.refHash,
      template: template != null ? template() : this.template,
      reply: reply != null ? reply() : this.reply,
      section: section != null ? section() : this.section,
      collabs: collabs != null ? collabs() : this.collabs,
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
      if (refHash != null) CoseHeaderKeys.refHash: refHash!.toCbor(),
      if (template != null) CoseHeaderKeys.template: template!.toCbor(),
      if (reply != null) CoseHeaderKeys.reply: reply!.toCbor(),
      if (section != null) CoseHeaderKeys.section: CborString(section!),
      if (brandId != null) CoseHeaderKeys.brandId: brandId!.toCbor(),
      if (campaignId != null) CoseHeaderKeys.campaignId: campaignId!.toCbor(),
      if (electionId != null) CoseHeaderKeys.electionId: CborString(electionId!),
      if (categoryId != null) CoseHeaderKeys.categoryId: categoryId!.toCbor(),
      if (collabs != null) CoseHeaderKeys.collabs: CborUtils.serializeStringList(collabs),
    });

    if (encodeAsBytes) {
      return CborBytes(cbor.encode(map));
    } else {
      return map;
    }
  }
}
