import 'package:catalyst_voices_models/src/document/data/document_data_content.dart';

/// Defines the content type of the [DocumentDataContent].
enum DocumentContentType {
  /// The document's content type is JSON.
  json('application/json'),

  /// The document's content type is JSON schema.
  schemaJson('application/json+schema'),

  /// Unrecognized content type.
  unknown('unknown');

  final String value;

  const DocumentContentType(this.value);

  static DocumentContentType fromJson(String data) {
    return DocumentContentType.values.firstWhere(
      (element) => element.value == data,
      orElse: () => DocumentContentType.unknown,
    );
  }

  static String toJson(DocumentContentType type) => type.value;
}
