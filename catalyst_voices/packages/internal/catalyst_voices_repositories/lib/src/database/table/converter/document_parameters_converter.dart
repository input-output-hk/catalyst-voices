import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_ref_dto.dart';
import 'package:drift/drift.dart';

/// A [TypeConverter] for converting [DocumentParameters] to and from a [String].
///
/// This converter is used by the drift database to store the [DocumentParameters]
/// object as a JSON string in the database.
class DocumentParametersConverter extends TypeConverter<DocumentParameters, String> {
  const DocumentParametersConverter();

  @override
  DocumentParameters fromSql(String fromDb) {
    if (fromDb.isEmpty) return const DocumentParameters();

    final jsonList = jsonDecode(fromDb);
    if (jsonList is! List<dynamic>) {
      return const DocumentParameters();
    }

    final refs = jsonList
        .cast<Map<String, dynamic>>()
        .map(DocumentRefDto.fromJson)
        .map((e) => e.toModel().toSignedDocumentRef())
        .toSet();

    return DocumentParameters(refs);
  }

  @override
  String toSql(DocumentParameters value) {
    if (value.set.isEmpty) return '[]';

    final decodedJson = <Map<String, dynamic>>[
      ...value.set.map(DocumentRefDto.fromModel).map((e) => e.toJson()),
    ];

    return jsonEncode(decodedJson);
  }
}
