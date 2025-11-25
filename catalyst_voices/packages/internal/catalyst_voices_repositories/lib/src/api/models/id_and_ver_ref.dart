import 'package:catalyst_voices_repositories/src/api/models/id_selector.dart';
import 'package:catalyst_voices_repositories/src/api/models/ver_selector.dart';
import 'package:json_annotation/json_annotation.dart';

part 'id_and_ver_ref.g.dart';

/// Either a Single Document ID, or a Range of Document IDs
@JsonSerializable(createFactory: false, includeIfNull: false)
final class IdAndVerRef {
  /// Document ID Reference
  /// A Reference to the Document ID Only.
  ///
  /// This will match any document that matches the defined Document ID only.
  /// The Document Version is not considered, and will match any version.
  final IdSelector? id;

  /// Document Version Selector
  /// Document Version, or Range of Document Versions
  final VerSelector? ver;

  /// Document ID Reference
  /// A Reference to the Document ID Only.
  ///
  /// This will match any document that matches the defined Document ID only.
  /// The Document Version is not considered, and will match any version.
  const IdAndVerRef.idOnly(IdSelector this.id) : ver = null;

  /// A Reference to the Document Version, and optionally also the Document ID.
  ///
  /// This will match any document that matches the defined Document Version and if
  /// specified the Document ID.
  /// If the Document ID is not specified, then all documents that match the version will be
  /// returned in the index.
  const IdAndVerRef.verWithOptionalId({
    required VerSelector this.ver,
    this.id,
  });

  Map<String, dynamic> toJson() => _$IdAndVerRefToJson(this);
}
