import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

final class SectionsControllerState extends Equatable {
  final List<Section> sections;
  final List<SectionsListViewItem> listItems;
  final Set<int> openedSections;
  final SectionStepId? activeStepId;

  factory SectionsControllerState({
    List<Section> sections = const [],
    Set<int> openedSections = const {},
    SectionStepId? activeStepId,
  }) {
    final listItems = sections
        .expand<SectionsListViewItem>((element) => [element, ...element.steps])
        .toList();

    return SectionsControllerState._(
      sections: sections,
      listItems: listItems,
      openedSections: openedSections,
      activeStepId: activeStepId,
    );
  }

  const SectionsControllerState._({
    this.sections = const [],
    this.listItems = const [],
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
        listItems,
        openedSections,
        activeStepId,
      ];
}

final class SectionsController extends ValueNotifier<SectionsControllerState> {
  ItemScrollController? _itemsScrollController;

  SectionsController([
    super.value = const SectionsControllerState._(),
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
