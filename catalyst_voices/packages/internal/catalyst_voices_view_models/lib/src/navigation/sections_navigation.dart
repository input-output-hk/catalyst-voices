import 'package:catalyst_voices_assets/generated/assets.gen.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

typedef SectionStepId = ({int sectionId, int stepId});

abstract interface class Section implements SectionsListViewItem {
  int get id;

  SvgGenImage get icon;

  List<SectionStep> get steps;

  String localizedName(BuildContext context);
}

abstract interface class SectionStep implements SectionsListViewItem {
  int get id;

  int get sectionId;

  SectionStepId get sectionStepId;

  bool get isEnabled;

  bool get isEditable;

  String localizedName(BuildContext context);
}

abstract base class BaseSection<T extends SectionStep> extends Equatable
    implements Section {
  @override
  final int id;
  @override
  final List<T> steps;

  const BaseSection({
    required this.id,
    required this.steps,
  });

  @override
  SvgGenImage get icon => VoicesAssets.icons.viewGrid;

  @override
  Key buildKey() => ValueKey('Section[$id]Key');

  @override
  List<Object?> get props => [
        id,
        steps,
      ];
}

abstract base class BaseSectionStep extends Equatable implements SectionStep {
  @override
  final int id;
  @override
  final int sectionId;
  @override
  final bool isEnabled;
  @override
  final bool isEditable;

  const BaseSectionStep({
    required this.id,
    required this.sectionId,
    this.isEnabled = true,
    this.isEditable = true,
  });

  @override
  SectionStepId get sectionStepId {
    return (sectionId: sectionId, stepId: id);
  }

  @override
  Key buildKey() => ValueKey('SectionStep[$sectionStepId]Key');

  @override
  List<Object?> get props => [
        id,
        sectionId,
        isEnabled,
        isEditable,
      ];
}
