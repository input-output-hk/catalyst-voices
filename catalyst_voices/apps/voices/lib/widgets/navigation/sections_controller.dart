import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

final class SectionsControllerState extends Equatable {
  final List<Section> sections;
  final Set<int> openedSections;
  final SectionStepId? activeStepId;
  final Set<SectionStepId> editStepsIds;

  const SectionsControllerState({
    this.sections = const [],
    this.openedSections = const {},
    this.activeStepId,
    this.editStepsIds = const {},
  });

  int? get activeSectionId => activeStepId?.sectionId;

  int? get activeStep => activeStepId?.stepId;

  bool get allSegmentsClosed => openedSections.isEmpty;

  List<SectionsListViewItem> get listItems {
    final openedSections = {...this.openedSections};

    return sections
        .expand<SectionsListViewItem>(
          (element) => [
            element,
            if (openedSections.contains(element.id)) ...element.steps,
          ],
        )
        .toList();
  }

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
    Set<SectionStepId>? editStepsIds,
  }) {
    return SectionsControllerState(
      sections: sections ?? this.sections,
      openedSections: openedSections ?? this.openedSections,
      activeStepId: activeStepId.dataOr(this.activeStepId),
      editStepsIds: editStepsIds ?? this.editStepsIds,
    );
  }

  @override
  List<Object?> get props => [
        sections,
        openedSections,
        activeStepId,
        editStepsIds,
      ];
}

final class SectionsController extends ValueNotifier<SectionsControllerState> {
  ItemScrollController? _itemsScrollController;

  SectionsController([
    super.value = const SectionsControllerState(),
  ]) : super();

  // ignore: use_setters_to_change_properties
  void attachItemsScrollController(ItemScrollController value) {
    _itemsScrollController = value;
  }

  void detachItemsScrollController() {
    _itemsScrollController = null;
  }

  void toggleSection(int id) {
    final openedSections = {...value.openedSections};
    final allSegmentsClosed = value.allSegmentsClosed;
    final shouldOpen = !openedSections.contains(id);

    Optional<SectionStepId>? activeStepId;

    if (shouldOpen) {
      openedSections.add(id);
    } else {
      openedSections.remove(id);
    }

    if (shouldOpen && allSegmentsClosed) {
      final section = value.sections.firstWhere((element) => element.id == id);

      final newStepId = section.steps.isNotEmpty
          ? (sectionId: section.id, stepId: section.steps.first.id)
          : null;

      if (newStepId != null) {
        activeStepId = Optional.of(newStepId);
        unawaited(_scrollToSectionStep(newStepId));
      }
    }

    //If user want to expand/hide segment and active step is not in the same section
    //it will not change the active section.
    //check if activeStepId is not null because if it is it should select
    //the first section of this segment id.
    if (value.activeSectionId != id && value.activeStepId != null) {
      activeStepId = Optional.of(value.activeStepId!);
    }

    value = value.copyWith(
      openedSections: openedSections,
      activeStepId: activeStepId,
    );
  }

  void selectSectionStep(SectionStepId id) {
    value = value.copyWith(activeStepId: Optional(id));

    unawaited(_scrollToSectionStep(id));
  }

  void focusSection(int id) {
    unawaited(_scrollToSection(id));
  }

  void editStep(
    SectionStepId id, {
    required bool enabled,
  }) {
    final editStepsIds = <SectionStepId>{...value.editStepsIds};
    Optional<SectionStepId>? activeStepId;

    if (enabled) {
      editStepsIds.add(id);
      activeStepId = Optional.of(id);
    } else {
      editStepsIds.remove(id);
    }

    value = value.copyWith(
      editStepsIds: editStepsIds,
      activeStepId: activeStepId,
    );
  }

  @override
  void dispose() {
    detachItemsScrollController();
    super.dispose();
  }

  Future<void> _scrollToSection(int id) async {
    final index = value.listItems.indexWhere((e) => e is Section && e.id == id);
    if (index == -1) {
      return;
    }

    await _scrollToIndex(index);
  }

  Future<void> _scrollToSectionStep(SectionStepId id) async {
    final index = value.listItems
        .indexWhere((e) => e is SectionStep && e.sectionStepId == id);
    if (index == -1) {
      return;
    }

    await _scrollToIndex(index);
  }

  Future<void> _scrollToIndex(int index) async {
    await _itemsScrollController?.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 300),
    );
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
