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

  List<Section2> get sections;

  String resolveTitle(BuildContext context);
}

abstract interface class Section2 implements SegmentsListViewItem {
  @override
  NodeId get id;

  bool get isEnabled;

  bool get isEditable;

  String resolveTitle(BuildContext context);
}

abstract base class BaseSegment<T extends Section2> extends Equatable
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

abstract base class BaseSection extends Equatable implements Section2 {
  @override
  final NodeId id;
  @override
  final bool isEnabled;
  @override
  final bool isEditable;

  const BaseSection({
    required this.id,
    this.isEnabled = true,
    this.isEditable = true,
  });

  @override
  @mustCallSuper
  List<Object?> get props => [
        id,
        isEnabled,
        isEditable,
      ];
}