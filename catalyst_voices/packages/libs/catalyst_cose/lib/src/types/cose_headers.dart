import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:catalyst_cose/src/utils/cbor_utils.dart';
import 'package:cbor/cbor.dart';
import 'package:collection/collection.dart';
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
  final CatalystIdKid? kid;

  /// See [CoseHeaderKeys.mediaType].
  final CoseMediaType? mediaType;

  /// See [CoseHeaderKeys.contentEncoding].
  final CoseHttpContentEncoding? contentEncoding;

  /// See [CoseHeaderKeys.type].
  final CoseDocumentType? type;

  /// See [CoseHeaderKeys.id].
  final CoseDocumentId? id;

  /// See [CoseHeaderKeys.ver].
  final CoseDocumentVer? ver;

  /// See [CoseHeaderKeys.ref].
  final CoseDocumentRefs? ref;

  /// See [CoseHeaderKeys.template].
  final CoseDocumentRefs? template;

  /// See [CoseHeaderKeys.reply].
  final CoseDocumentRefs? reply;

  /// See [CoseHeaderKeys.section].
  final CoseSectionRef? section;

  /// See [CoseHeaderKeys.collaborators].
  ///
  /// Replaces the old [CoseHeaderKeys.collabs] key.
  final CoseCollaborators? collaborators;

  /// See [CoseHeaderKeys.parameters].
  ///
  /// Replaces:
  /// - [CoseHeaderKeys.brandId]
  /// - [CoseHeaderKeys.campaignId]
  /// - [CoseHeaderKeys.categoryId]
  final CoseDocumentRefs? parameters;

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
    this.mediaType,
    this.contentEncoding,
    this.type,
    this.id,
    this.ver,
    this.ref,
    this.template,
    this.reply,
    this.section,
    this.collaborators,
    this.parameters,
    required this.encodeAsBytes,
  });

  /// Deserializes the type from cbor.
  factory CoseHeaders.fromCbor(CborValue value, {bool encodeAsBytes = true}) {
    var map = _decodeCbor(value);
    map = _migrateCbor1(map);
    map = _migrateCbor2(map);
    map = _migrateCbor3(map);

    return CoseHeaders(
      alg: CborUtils.deserializeStringOrInt(map[CoseHeaderKeys.alg]),
      kid: CborUtils.deserializeKid(map[CoseHeaderKeys.kid]),
      mediaType: CborUtils.deserializeMediaType(map[CoseHeaderKeys.mediaType]),
      contentEncoding: CborUtils.deserializeHttpContentEncoding(
        map[CoseHeaderKeys.contentEncoding],
      ),
      type: CborUtils.deserializeDocumentType(map[CoseHeaderKeys.type]),
      id: CborUtils.deserializeDocumentId(map[CoseHeaderKeys.id]),
      ver: CborUtils.deserializeDocumentVer(map[CoseHeaderKeys.ver]),
      ref: CborUtils.deserializeDocumentRefs(map[CoseHeaderKeys.ref]),
      template: CborUtils.deserializeDocumentRefs(map[CoseHeaderKeys.template]),
      reply: CborUtils.deserializeDocumentRefs(map[CoseHeaderKeys.reply]),
      section: CborUtils.deserializeSectionRef(map[CoseHeaderKeys.section]),
      collaborators: CborUtils.deserializeCollaborators(map[CoseHeaderKeys.collaborators]),
      parameters: CborUtils.deserializeDocumentRefs(map[CoseHeaderKeys.parameters]),
      encodeAsBytes: encodeAsBytes,
    );
  }

  /// The constructor for the protected [CoseHeaders].
  const CoseHeaders.protected({
    this.alg,
    this.kid,
    this.mediaType,
    this.contentEncoding,
    this.type,
    this.id,
    this.ver,
    this.ref,
    this.template,
    this.reply,
    this.section,
    this.collaborators,
    this.parameters,
  }) : encodeAsBytes = true;

  /// The constructor for the unprotected [CoseHeaders].
  const CoseHeaders.unprotected({
    this.alg,
    this.kid,
    this.mediaType,
    this.contentEncoding,
    this.type,
    this.id,
    this.ver,
    this.ref,
    this.template,
    this.reply,
    this.section,
    this.collaborators,
    this.parameters,
  }) : encodeAsBytes = false;

  @override
  List<Object?> get props => [
    alg,
    kid,
    mediaType,
    contentEncoding,
    type,
    id,
    ver,
    ref,
    template,
    reply,
    section,
    collaborators,
    parameters,
    encodeAsBytes,
  ];

  /// Returns a copy of the [CoseHeaders] with overwritten properties.
  CoseHeaders copyWith({
    OptionalValueGetter<CoseStringOrInt?>? alg,
    OptionalValueGetter<CatalystIdKid?>? kid,
    OptionalValueGetter<CoseMediaType?>? mediaType,
    OptionalValueGetter<CoseHttpContentEncoding?>? contentEncoding,
    OptionalValueGetter<CoseDocumentType?>? type,
    OptionalValueGetter<CoseDocumentId?>? id,
    OptionalValueGetter<CoseDocumentVer?>? ver,
    OptionalValueGetter<CoseDocumentRefs?>? ref,
    OptionalValueGetter<CoseDocumentRefs?>? template,
    OptionalValueGetter<CoseDocumentRefs?>? reply,
    OptionalValueGetter<CoseSectionRef?>? section,
    OptionalValueGetter<CoseCollaborators?>? collaborators,
    OptionalValueGetter<CoseDocumentRefs?>? parameters,
    bool? encodeAsBytes,
  }) {
    return CoseHeaders(
      alg: alg != null ? alg() : this.alg,
      kid: kid != null ? kid() : this.kid,
      mediaType: mediaType != null ? mediaType() : this.mediaType,
      contentEncoding: contentEncoding != null ? contentEncoding() : this.contentEncoding,
      type: type != null ? type() : this.type,
      id: id != null ? id() : this.id,
      ver: ver != null ? ver() : this.ver,
      ref: ref != null ? ref() : this.ref,
      template: template != null ? template() : this.template,
      reply: reply != null ? reply() : this.reply,
      section: section != null ? section() : this.section,
      collaborators: collaborators != null ? collaborators() : this.collaborators,
      parameters: parameters != null ? parameters() : this.parameters,
      encodeAsBytes: encodeAsBytes ?? this.encodeAsBytes,
    );
  }

  /// Serializes the type as cbor.
  CborValue toCbor() {
    final map = CborMap({
      if (alg case final alg?) CoseHeaderKeys.alg: alg.toCbor(),
      if (kid case final kid?) CoseHeaderKeys.kid: kid.toCbor(),
      if (mediaType case final contentType?) CoseHeaderKeys.mediaType: contentType.toCbor(),
      if (contentEncoding case final contentEncoding?)
        CoseHeaderKeys.contentEncoding: contentEncoding.toCbor(),
      if (type case final type?) CoseHeaderKeys.type: type.toCbor(),
      if (id case final id?) CoseHeaderKeys.id: id!.toCbor(),
      if (ver case final ver?) CoseHeaderKeys.ver: ver!.toCbor(),
      if (ref case final ref?) CoseHeaderKeys.ref: ref.toCbor(),
      if (template case final template?) CoseHeaderKeys.template: template.toCbor(),
      if (reply case final reply?) CoseHeaderKeys.reply: reply.toCbor(),
      if (section case final section?) CoseHeaderKeys.section: section.toCbor(),
      if (parameters case final parameters?) CoseHeaderKeys.parameters: parameters.toCbor(),
      if (collaborators case final collaborators?)
        CoseHeaderKeys.collaborators: collaborators.toCbor(),
    });

    if (encodeAsBytes) {
      return CborBytes(cbor.encode(map));
    } else {
      return map;
    }
  }

  static CborMap _decodeCbor(CborValue value) {
    if (value is CborMap) {
      // cose headers per specification might be wrapped in extra CborBytes,
      // both formats are valid
      return value;
    } else {
      final cborBytes = value as CborBytes;
      final encodedMap = cbor.decode(cborBytes.bytes);
      return encodedMap as CborMap;
    }
  }

  /// v0.0.1 -> v0.0.4 spec: https://github.com/input-output-hk/catalyst-libs/pull/341/files#diff-2827956d681587dfd09dc733aca731165ff44812f8322792bf6c4a61cf2d3b85
  ///
  /// Migrate "brandId", "campaignId" and "categoryId" into "parameters".
  static CborMap _migrateCbor1(CborMap map) {
    final parametersKeys = [
      CoseHeaderKeys.brandId,
      CoseHeaderKeys.campaignId,
      CoseHeaderKeys.categoryId,
    ];

    if (parametersKeys.none(map.containsKey)) {
      return map;
    } else {
      final modified = CborMap.fromEntries(map.entries, tags: map.tags, type: map.type);
      final parameters = <CoseDocumentRef>[];

      for (final key in parametersKeys) {
        final value = modified.remove(key);
        if (value != null) {
          parameters.add(CoseDocumentRef.fromCbor(value));
        }
      }

      modified[CoseHeaderKeys.parameters] = CoseDocumentRefs(parameters).toCbor();
      return modified;
    }
  }

  /// v0.0.1 -> v0.0.4 spec: https://github.com/input-output-hk/catalyst-libs/pull/341/files#diff-2827956d681587dfd09dc733aca731165ff44812f8322792bf6c4a61cf2d3b85
  ///
  /// Migrate "collabs" into "collaborators".
  static CborMap _migrateCbor2(CborMap map) {
    if (map.containsKey(CoseHeaderKeys.collabs)) {
      final modified = CborMap.fromEntries(map.entries, tags: map.tags, type: map.type);
      modified[CoseHeaderKeys.collaborators] = map.remove(CoseHeaderKeys.collabs)!;
      return modified;
    } else {
      return map;
    }
  }

  /// v0.0.1 -> v0.0.4 spec: https://github.com/input-output-hk/catalyst-libs/pull/341/files#diff-2827956d681587dfd09dc733aca731165ff44812f8322792bf6c4a61cf2d3b85
  ///
  /// Migrate "Content-Encoding" into "content-encoding".
  static CborMap _migrateCbor3(CborMap map) {
    final oldKey = CborString('Content-Encoding');
    final newKey = CoseHeaderKeys.contentEncoding;
    if (map.containsKey(oldKey)) {
      final modified = CborMap.fromEntries(map.entries, tags: map.tags, type: map.type);
      modified[newKey] = map.remove(oldKey)!;
      return modified;
    } else {
      return map;
    }
  }
}
