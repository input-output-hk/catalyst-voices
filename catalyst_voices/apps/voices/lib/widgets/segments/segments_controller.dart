import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

final class SegmentsController extends ValueNotifier<SegmentsControllerState> {
  ItemScrollController? _itemsScrollController;

  SegmentsController([
    super.value = const SegmentsControllerState(),
  ]) : super();

  // ignore: use_setters_to_change_properties
  void attachItemsScrollController(ItemScrollController value) {
    _itemsScrollController = value;
  }

  void detachItemsScrollController() {
    _itemsScrollController = null;
  }

  @override
  void dispose() {
    detachItemsScrollController();
    super.dispose();
  }

  void editSection(
    NodeId id, {
    required bool enabled,
  }) {
    final editSectionId = <NodeId>{...value.editSectionId};
    Optional<NodeId>? activeSectionId;

    if (enabled) {
      editSectionId.add(id);
      activeSectionId = Optional.of(id);
    } else {
      editSectionId.remove(id);
    }

    value = value.copyWith(
      editSectionId: editSectionId,
      activeSectionId: activeSectionId,
    );
  }

  void focusSection(NodeId id) {
    unawaited(_scrollTo(id));
  }

  void selectSectionStep(NodeId id) {
    value = value.copyWith(activeSectionId: Optional(id));

    unawaited(_scrollTo(id));
  }

  void toggleSegment(NodeId id) {
    final openedSegments = {...value.openedSegments};
    final allSegmentsClosed = value.allSegmentsClosed;
    final shouldOpen = !openedSegments.contains(id);

    Optional<NodeId>? activeSectionId;

    if (shouldOpen) {
      openedSegments.add(id);
    } else {
      openedSegments.remove(id);
    }

    if (shouldOpen && allSegmentsClosed) {
      final segment = value.segments.firstWhere((element) => element.id == id);

      final newSectionId = segment.sections.firstOrNull?.id;

      if (newSectionId != null) {
        activeSectionId = Optional.of(newSectionId);
        unawaited(_scrollTo(newSectionId));
      }
    }

    // If user want to expand/hide segment and active section is not in the same
    // segment it will not change the active segment.
    //
    // check if activeSectionId is not null because if it is it should select
    // the first segment of this segment id.
    if (value.activeSectionId?.isChildOf(id) == false) {
      activeSectionId = Optional(value.activeSectionId);
    }

    value = value.copyWith(
      openedSegments: openedSegments,
      activeSectionId: activeSectionId,
    );
  }

  Future<void> _scrollTo(NodeId id) async {
    final listItems = value.listItems;
    var index = listItems.indexWhere((e) => e.id == id);

    if (index == -1) {
      index = listItems.indexWhere((e) => e.id.isChildOf(id));
    }

    if (index == -1) {
      return;
    }

    await _scrollToIndex(index);
  }

  Future<void> _scrollToIndex(int index) async {
    final controller = _itemsScrollController;
    if (controller == null || !controller.isAttached) {
      return;
    }

    await controller.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 300),
    );
  }
}

final class SegmentsControllerScope extends InheritedWidget {
  final SegmentsController controller;

  const SegmentsControllerScope({
    super.key,
    required this.controller,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant SegmentsControllerScope oldWidget) {
    return controller != oldWidget.controller;
  }

  static SegmentsController of(BuildContext context) {
    final controller = context
        .dependOnInheritedWidgetOfExactType<SegmentsControllerScope>()
        ?.controller;

    assert(
      controller != null,
      'Unable to find SegmentsControllerScope in widget tree',
    );

    return controller!;
  }
}

final class SegmentsControllerState extends Equatable {
  final List<Segment> segments;
  final Set<NodeId> openedSegments;
  final NodeId? activeSectionId;
  final Set<NodeId> editSectionId;

  const SegmentsControllerState({
    this.segments = const [],
    this.openedSegments = const {},
    this.activeSectionId,
    this.editSectionId = const {},
  });

  /// All [segments] are opened and first section is selected.
  factory SegmentsControllerState.initial({
    required List<Segment> segments,
    NodeId? activeSectionId,
  }) {
    final allSegmentsIds = segments.map((e) => e.id).toSet();
    final segment = segments.firstWhereOrNull((e) => e.sections.isNotEmpty);

    return SegmentsControllerState(
      segments: segments,
      openedSegments: allSegmentsIds,
      activeSectionId: activeSectionId ?? segment?.sections.first.id,
    );
  }

  bool get allSegmentsClosed => openedSegments.isEmpty;

  List<SegmentsListViewItem> get listItems {
    final openedSegments = {...this.openedSegments};

    return segments
        .expand<SegmentsListViewItem>(
          (element) => [
            element,
            if (openedSegments.contains(element.id)) ...element.sections,
          ],
        )
        .expand(
          (element) => [
            element,
            if (element is SegmentGroupedListViewItems)
              ...(element as SegmentGroupedListViewItems).children,
          ],
        )
        .toList();
  }

  @override
  List<Object?> get props => [
        segments,
        openedSegments,
        activeSectionId,
        editSectionId,
      ];

  SegmentsControllerState copyWith({
    List<Segment>? segments,
    Set<NodeId>? openedSegments,
    Optional<NodeId>? activeSectionId,
    Set<NodeId>? editSectionId,
  }) {
    return SegmentsControllerState(
      segments: segments ?? this.segments,
      openedSegments: openedSegments ?? this.openedSegments,
      activeSectionId: activeSectionId.dataOr(this.activeSectionId),
      editSectionId: editSectionId ?? this.editSectionId,
    );
  }

  bool isEditing(NodeId stepId) {
    return editSectionId.contains(stepId);
  }
}
