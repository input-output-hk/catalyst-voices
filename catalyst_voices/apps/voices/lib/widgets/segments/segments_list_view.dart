import 'package:catalyst_voices/widgets/segments/segment_header_tile.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

typedef SegmentHeaderWidgetBuilder<T extends Segment> = Widget Function(
  BuildContext context,
  T data,
);

typedef SectionWidgetBuilder<T extends Section2> = Widget Function(
  BuildContext context,
  T data,
);

class SegmentsListView<TSegment extends Segment, TSection extends Section2>
    extends StatelessWidget {
  final List<SegmentsListViewItem> items;
  final SegmentHeaderWidgetBuilder<TSegment> headerBuilder;
  final SectionWidgetBuilder<TSection> sectionBuilder;
  final EdgeInsetsGeometry? padding;
  final ItemScrollController? itemScrollController;

  const SegmentsListView({
    super.key,
    required this.items,
    this.headerBuilder = _defaultSegmentHeaderBuilder,
    required this.sectionBuilder,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
    this.itemScrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        // Disables the iOS like overscroll behavior to avoid jumping UI.
        // TODO(dtscalac): remove the workaround when
        // https://github.com/google/flutter.widgets/issues/276 is fixed
        physics: const ClampingScrollPhysics(),
      ),
      child: ScrollablePositionedList.separated(
        padding: padding?.resolve(Directionality.of(context)),
        itemScrollController: itemScrollController,
        itemBuilder: (context, index) {
          final item = items[index];

          if (item is TSegment) {
            return KeyedSubtree(
              key: ValueKey(item.id),
              child: headerBuilder(context, item),
            );
          }

          if (item is TSection) {
            return KeyedSubtree(
              key: ValueKey(item.id),
              child: sectionBuilder(context, item),
            );
          }

          throw ArgumentError('Unknown item type[${item.runtimeType}]');
        },
        separatorBuilder: (context, index) {
          final item = items[index];

          if (item is TSegment) {
            return const SizedBox(height: 12);
          }

          if (item is TSection) {
            return const SizedBox(height: 12);
          }

          throw ArgumentError('Unknown item type[${item.runtimeType}]');
        },
        itemCount: items.length,
      ),
    );
  }
}

Widget _defaultSegmentHeaderBuilder(BuildContext context, Segment data) {
  return SegmentHeaderTile(
    id: data.id,
    name: data.resolveTitle(context),
  );
}
