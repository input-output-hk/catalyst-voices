import 'package:catalyst_voices_assets/generated/assets.gen.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

typedef SectionStepId = ({int sectionId, int stepId});

abstract interface class Section {
  int get id;

  SvgGenImage get icon;

  List<SectionStep> get steps;

  String localizedName(BuildContext context);
}

abstract interface class SectionStep {
  int get id;

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
  List<Object?> get props => [
        id,
        steps,
      ];
}

abstract base class BaseSectionStep extends Equatable implements SectionStep {
  @override
  final int id;
  @override
  final bool isEnabled;
  @override
  final bool isEditable;

  const BaseSectionStep({
    required this.id,
    this.isEnabled = true,
    this.isEditable = true,
  });

  @override
  List<Object?> get props => [
        id,
        isEnabled,
        isEditable,
      ];
}
