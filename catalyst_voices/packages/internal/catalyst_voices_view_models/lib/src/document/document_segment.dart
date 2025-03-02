import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

final class DocumentSection extends BaseSection {
  final DocumentProperty property;
  final DocumentPropertySchema schema;

  const DocumentSection({
    required super.id,
    required this.property,
    required this.schema,
    super.isEnabled,
    super.isEditable,
    super.hasError,
  });

  @override
  List<Object?> get props => super.props + [property, schema];

  @override
  String resolveTitle(BuildContext context) {
    return property.schema.title;
  }
}

final class DocumentSegment extends BaseSegment<DocumentSection> {
  final DocumentObjectProperty property;
  final DocumentSegmentSchema schema;

  const DocumentSegment({
    required super.id,
    required super.sections,
    required this.property,
    required this.schema,
  });

  @override
  SvgGenImage get icon {
    final iconAsset = schema.icon;
    if (iconAsset != null) {
      return VoicesAssets.icons.getIcon(iconAsset);
    } else {
      return VoicesAssets.icons.viewGrid;
    }
  }

  @override
  List<Object?> get props => super.props + [property, schema];

  @override
  String resolveTitle(BuildContext context) {
    return property.schema.title;
  }
}
