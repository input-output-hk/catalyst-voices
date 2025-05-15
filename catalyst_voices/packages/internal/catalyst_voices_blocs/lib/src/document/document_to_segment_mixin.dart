import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

mixin DocumentToSegmentMixin {
  List<DocumentSegment> mapDocumentToSegments(
    Document document, {
    bool showValidationErrors = false,
    List<DocumentNodeId> filterOut = const [],
  }) {
    final result = <DocumentSegment>[];

    final effectiveSegments =
        document.segments.where((element) => !filterOut.contains(element.nodeId)).toList();

    for (final segment in effectiveSegments) {
      final sections = segment.sections
          .expand(DocumentNodeTraverser.findSectionsAndSubsections)
          .where((element) => !filterOut.contains(element.nodeId))
          .map((section) {
        return DocumentSection(
          id: section.schema.nodeId,
          property: section,
          schema: section.schema,
          hasError: showValidationErrors && !section.isValidExcludingSubsections,
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
