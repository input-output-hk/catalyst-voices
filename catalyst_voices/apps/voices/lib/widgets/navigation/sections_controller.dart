import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class SectionsControllerState extends Equatable {
  final List<Section> sections;
  final Set<int> openedSections;
  final SectionStepId? selectedStep;

  const SectionsControllerState({
    this.sections = const [],
    this.openedSections = const {},
    this.selectedStep,
  });

  factory SectionsControllerState.initial({
    required List<Section> sections,
  }) {
    final openedSections = sections.map((e) => e.id).toSet();

    final section = sections.firstWhereOrNull((e) => e.steps.isNotEmpty);

    final selectedStep = section != null
        ? (sectionId: section.id, stepId: section.steps.first.id)
        : null;

    return SectionsControllerState(
      sections: sections,
      openedSections: openedSections,
      selectedStep: selectedStep,
    );
  }

  SectionsControllerState copyWith({
    List<Section>? sections,
    Set<int>? openedSections,
    Optional<SectionStepId>? selectedStep,
  }) {
    return SectionsControllerState(
      sections: sections ?? this.sections,
      openedSections: openedSections ?? this.openedSections,
      selectedStep: selectedStep.dataOr(this.selectedStep),
    );
  }

  @override
  List<Object?> get props => [
        sections,
        openedSections,
        selectedStep,
      ];
}

final class SectionsController extends ValueNotifier<SectionsControllerState> {
  SectionsController([super.value = const SectionsControllerState()]) : super();

  void toggleSection(int id) {
    final openedSections = {...value.openedSections};
    var selectedStep = value.selectedStep;

    if (openedSections.contains(id)) {
      openedSections.remove(id);

      if (selectedStep?.sectionId == id) {
        selectedStep = null;
      }
    } else {
      openedSections.add(id);
    }

    value = value.copyWith(
      openedSections: openedSections,
      selectedStep: Optional(selectedStep),
    );
  }

  void selectSectionStep(SectionStepId id) {
    final selectedStep = value.selectedStep;

    if (selectedStep == id) {
      value = value.copyWith(selectedStep: const Optional.empty());
    } else {
      value = value.copyWith(selectedStep: Optional(id));
    }
  }
}

final class SectionsControllerScope extends InheritedWidget {
  final SectionsController controller;

  const SectionsControllerScope({
    super.key,
    required this.controller,
    required super.child,
  });

  static SectionsController of(BuildContext context) {
    final controller = context
        .dependOnInheritedWidgetOfExactType<SectionsControllerScope>()
        ?.controller;

    assert(
      controller != null,
      'Unable to find SectionsControllerScope in widget tree',
    );

    return controller!;
  }

  @override
  bool updateShouldNotify(covariant SectionsControllerScope oldWidget) {
    return controller != oldWidget.controller;
  }
}
