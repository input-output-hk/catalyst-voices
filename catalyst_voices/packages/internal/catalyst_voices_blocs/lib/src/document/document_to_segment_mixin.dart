import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

mixin DocumentToSegmentMixin {
  List<DocumentSegment> mapDocumentToSegments(
    Document document, {
    bool showValidationErrors = false,
  }) {
    final result = <DocumentSegment>[];

    for (final segment in document.segments) {
      final sections = segment.sections
          .expand(DocumentNodeTraverser.findSectionsAndSubsections)
          .map((section) {
        return DocumentSection(
          id: section.schema.nodeId,
          property: section,
          schema: section.schema,
          isEnabled: true,
          isEditable: true,
          hasError:
              showValidationErrors && !section.isValidExcludingSubsections,
        );
      }).toList();

      final documentSegment = DocumentSegment(
        id: segment.schema.nodeId,
        sections: sections,
        property: segment,
        schema: segment.schema as DocumentSegmentSchema,
      );

      result.add(documentSegment);
    }

    return result;
  }
}
