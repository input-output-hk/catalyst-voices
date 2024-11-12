import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class SectionsControllerState extends Equatable {
  final List<Section> sections;
  final Set<int> openedSections;
  final SectionStepId? activeStepId;

  const SectionsControllerState({
    this.sections = const [],
    this.openedSections = const {},
    this.activeStepId,
  });

  int? get activeSectionId => activeStepId?.sectionId;

  bool get allSegmentsClosed => openedSections.isEmpty;

  /// All [sections] are opened and first section is selected.
  factory SectionsControllerState.initial({
    required List<Section> sections,
  }) {
    final openedSections = sections.map((e) => e.id).toSet();

    final section = sections.firstWhereOrNull((e) => e.steps.isNotEmpty);

    final activeStepId = section != null
        ? (sectionId: section.id, stepId: section.steps.first.id)
        : null;

    return SectionsControllerState(
      sections: sections,
      openedSections: openedSections,
      activeStepId: activeStepId,
    );
  }

  SectionsControllerState copyWith({
    List<Section>? sections,
    Set<int>? openedSections,
    Optional<SectionStepId>? activeStepId,
  }) {
    return SectionsControllerState(
      sections: sections ?? this.sections,
      openedSections: openedSections ?? this.openedSections,
      activeStepId: activeStepId.dataOr(this.activeStepId),
    );
  }

  @override
  List<Object?> get props => [
        sections,
        openedSections,
        activeStepId,
      ];
}

final class SectionsController extends ValueNotifier<SectionsControllerState> {
  SectionsController([super.value = const SectionsControllerState()]) : super();

  void toggleSection(int id) {
    final openedSections = {...value.openedSections};

    if (openedSections.contains(id)) {
      openedSections.remove(id);
    } else {
      openedSections.add(id);
    }

    value = value.copyWith(
      openedSections: openedSections,
    );
  }

  void selectSectionStep(SectionStepId id) {
    value = value.copyWith(activeStepId: Optional(id));
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
