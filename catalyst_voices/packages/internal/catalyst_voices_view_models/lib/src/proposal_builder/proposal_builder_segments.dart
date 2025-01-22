import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';

final class ProposalBuilderSegment extends BaseSegment<ProposalBuilderSection> {
  final DocumentObjectProperty property;
  final DocumentSegmentSchema schema;

  const ProposalBuilderSegment({
    required super.id,
    required super.sections,
    required this.property,
    required this.schema,
  });

  @override
  SvgGenImage get icon {
    final iconAsset = schema.icon;
    if (iconAsset == null) {
      return VoicesAssets.icons.viewGrid;
    } else {
      return VoicesAssets.icons.getIcon(iconAsset);
    }
  }

  @override
  String resolveTitle(BuildContext context) {
    return property.schema.title;
  }

  @override
  List<Object?> get props => super.props + [property, schema];
}

final class ProposalBuilderSection extends BaseSection {
  final DocumentObjectProperty documentSection;

  const ProposalBuilderSection({
    required super.id,
    required this.documentSection,
    super.isEnabled,
    super.isEditable,
  });

  @override
  String resolveTitle(BuildContext context) {
    return documentSection.schema.title;
  }

  @override
  List<Object?> get props => super.props + [documentSection];
}
