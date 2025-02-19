import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

abstract interface class SegmentsListViewItem {
  NodeId get id;
}

abstract interface class Segment implements SegmentsListViewItem {
  @override
  NodeId get id;

  SvgGenImage get icon;

  List<Section> get sections;

  String resolveTitle(BuildContext context);
}

abstract interface class Section implements SegmentsListViewItem {
  @override
  NodeId get id;

  bool get isEnabled;

  bool get isEditable;

  bool get hasError;

  String resolveTitle(BuildContext context);
}

abstract base class BaseSegment<T extends Section> extends Equatable
    implements Segment {
  @override
  final NodeId id;
  @override
  final List<T> sections;

  const BaseSegment({
    required this.id,
    required this.sections,
  });

  @override
  SvgGenImage get icon => VoicesAssets.icons.viewGrid;

  @override
  @mustCallSuper
  List<Object?> get props => [id, sections];
}

abstract base class BaseSection extends Equatable implements Section {
  @override
  final NodeId id;
  @override
  final bool isEnabled;
  @override
  final bool isEditable;
  @override
  final bool hasError;

  const BaseSection({
    required this.id,
    this.isEnabled = true,
    this.isEditable = true,
    this.hasError = false,
  });

  @override
  @mustCallSuper
  List<Object?> get props => [
        id,
        isEnabled,
        isEditable,
        hasError,
      ];
}
