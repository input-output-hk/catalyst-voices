import 'package:catalyst_cose/src/cose_constants.dart';
import 'package:catalyst_cose/src/types/string_or_int.dart';
import 'package:catalyst_cose/src/types/uuid.dart';
import 'package:catalyst_cose/src/utils/cbor_utils.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

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
  final String? kid;

  /// See [CoseHeaderKeys.contentType].
  final StringOrInt? contentType;

  /// See [CoseHeaderKeys.contentEncoding].
  final StringOrInt? contentEncoding;

  /// See [CoseHeaderKeys.type].
  final Uuid? type;

  /// See [CoseHeaderKeys.id].
  final Uuid? id;

  /// See [CoseHeaderKeys.ver].
  final Uuid? ver;

  /// See [CoseHeaderKeys.ref].
  final ReferenceUuid? ref;

  /// See [CoseHeaderKeys.template].
  final ReferenceUuid? template;

  /// See [CoseHeaderKeys.reply].
  final ReferenceUuid? reply;

  /// See [CoseHeaderKeys.section].
  final String? section;

  /// See [CoseHeaderKeys.collabs].
  final List<String>? collabs;

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
    this.collabs,
    required this.encodeAsBytes,
  });

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
    this.collabs,
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
    this.collabs,
  }) : encodeAsBytes = false;

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
      kid: CborUtils.deserializeString(map[CoseHeaderKeys.kid]),
      contentType:
          CborUtils.deserializeStringOrInt(map[CoseHeaderKeys.contentType]),
      contentEncoding:
          CborUtils.deserializeStringOrInt(map[CoseHeaderKeys.contentEncoding]),
      type: CborUtils.deserializeUuid(map[CoseHeaderKeys.type]),
      id: CborUtils.deserializeUuid(map[CoseHeaderKeys.id]),
      ver: CborUtils.deserializeUuid(map[CoseHeaderKeys.ver]),
      ref: CborUtils.deserializeReferenceUuid(map[CoseHeaderKeys.ref]),
      template:
          CborUtils.deserializeReferenceUuid(map[CoseHeaderKeys.template]),
      reply: CborUtils.deserializeReferenceUuid(map[CoseHeaderKeys.reply]),
      section: CborUtils.deserializeString(map[CoseHeaderKeys.section]),
      collabs: CborUtils.deserializeStringList(map[CoseHeaderKeys.collabs]),
      encodeAsBytes: encodeAsBytes,
    );
  }

  /// Serializes the type as cbor.
  CborValue toCbor() {
    final map = CborMap({
      if (alg != null) CoseHeaderKeys.alg: alg!.toCbor(),
      if (kid != null) CoseHeaderKeys.kid: CborString(kid!),
      if (contentType != null)
        CoseHeaderKeys.contentType: contentType!.toCbor(),
      if (contentEncoding != null)
        CoseHeaderKeys.contentEncoding: contentEncoding!.toCbor(),
      if (type != null) CoseHeaderKeys.type: type!.toCbor(),
      if (id != null) CoseHeaderKeys.id: id!.toCbor(),
      if (ver != null) CoseHeaderKeys.ver: ver!.toCbor(),
      if (ref != null) CoseHeaderKeys.ref: ref!.toCbor(),
      if (template != null) CoseHeaderKeys.template: template!.toCbor(),
      if (reply != null) CoseHeaderKeys.reply: reply!.toCbor(),
      if (section != null) CoseHeaderKeys.section: CborString(section!),
      if (collabs != null)
        CoseHeaderKeys.collabs: CborUtils.serializeStringList(collabs),
    });

    if (encodeAsBytes) {
      return CborBytes(cbor.encode(map));
    } else {
      return map;
    }
  }

  /// Returns a copy of the [CoseHeaders] with given [alg] and [kid].
  CoseHeaders copyWith({
    required StringOrInt? alg,
    required String? kid,
  }) {
    return CoseHeaders(
      alg: alg,
      kid: kid,
      contentType: contentType,
      contentEncoding: contentEncoding,
      type: type,
      id: id,
      ver: ver,
      ref: ref,
      template: template,
      reply: reply,
      section: section,
      collabs: collabs,
      encodeAsBytes: encodeAsBytes,
    );
  }

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
        collabs,
        encodeAsBytes,
      ];
}
