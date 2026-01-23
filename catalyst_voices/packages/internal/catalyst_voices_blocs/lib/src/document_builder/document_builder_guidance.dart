import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// A callback to generate a custom property title for a [DocumentProperty].
///
/// Returning null will use the default title of the [property].
typedef DocumentBuilderGuidancePropertyTitleGenerator = String? Function(DocumentProperty property);

/// A list of [DocumentBuilderGuidanceItem] related to a [DocumentSection] or [DocumentSegment].
final class DocumentBuilderGuidance extends Equatable {
  final bool isNoneSelected;
  final List<DocumentBuilderGuidanceItem> guidanceList;

  const DocumentBuilderGuidance({
    this.isNoneSelected = false,
    this.guidanceList = const [],
  });

  /// Creates the [DocumentBuilderGuidance] for all properties of the [section] in given [segment].
  ///
  /// The [titleGenerator] can optionally be used to override the property title.
  factory DocumentBuilderGuidance.create(
    DocumentSegment? segment,
    DocumentSection? section, {
    DocumentBuilderGuidancePropertyTitleGenerator? titleGenerator,
  }) {
    if (segment == null || section == null) {
      return const DocumentBuilderGuidance();
    } else {
      return DocumentBuilderGuidance(
        guidanceList: _findGuidanceItems(
          segment,
          section,
          section.property,
          titleGenerator,
        ).toList(),
      );
    }
  }

  @override
  List<Object?> get props => [
    isNoneSelected,
    guidanceList,
  ];

  bool get showEmptyState => !isNoneSelected && guidanceList.isEmpty;

  static Iterable<DocumentBuilderGuidanceItem> _findGuidanceItems(
    DocumentSegment segment,
    DocumentSection section,
    DocumentProperty property,
    DocumentBuilderGuidancePropertyTitleGenerator? titleGenerator,
  ) sync* {
    if (property.schema.isSubsection && section.id != property.nodeId) {
      // Since the property is a standalone subsection we cannot
      // lookup guidance items for it in a context of given section.
      return;
    }

    final guidance = property.schema.guidance;
    final sectionTitle = titleGenerator?.call(property) ?? property.schema.title;

    if (guidance != null) {
      yield DocumentBuilderGuidanceItem(
        segmentTitle: segment.schema.title,
        sectionTitle: sectionTitle,
        description: guidance,
        nodeId: property.nodeId,
      );
    }

    switch (property) {
      case DocumentListProperty():
        for (final childProperty in property.properties) {
          yield* _findGuidanceItems(segment, section, childProperty, titleGenerator);
        }
      case DocumentObjectProperty():
        for (final childProperty in property.properties) {
          yield* _findGuidanceItems(segment, section, childProperty, titleGenerator);
        }
      case DocumentValueProperty():
      // do nothing, values don't have children
    }
  }
}

/// A guidance data of the [DocumentProperty] identified by [nodeId].
final class DocumentBuilderGuidanceItem extends Equatable {
  final String segmentTitle;
  final String sectionTitle;
  final MarkdownData description;
  final DocumentNodeId nodeId;

  const DocumentBuilderGuidanceItem({
    required this.segmentTitle,
    required this.sectionTitle,
    required this.description,
    required this.nodeId,
  });

  @override
  List<Object?> get props => [
    segmentTitle,
    sectionTitle,
    description,
    nodeId,
  ];
}
