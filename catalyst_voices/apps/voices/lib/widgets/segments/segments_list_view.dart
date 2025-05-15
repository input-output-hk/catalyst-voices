import 'package:catalyst_voices/widgets/segments/segment_header_tile.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

Widget _defaultSegmentHeaderBuilder(BuildContext context, Segment data) {
  return SegmentHeaderTile(
    id: data.id,
    name: data.resolveTitle(context),
  );
}

typedef SectionWidgetBuilder<T extends Section> = Widget Function(
  BuildContext context,
  T data,
);

typedef SegmentHeaderWidgetBuilder<T extends Segment> = Widget Function(
  BuildContext context,
  T data,
);

class BasicSegmentsListView extends StatelessWidget {
  final List<SegmentsListViewItem> items;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder separatorBuilder;
  final EdgeInsetsGeometry? padding;
  final ItemScrollController? itemScrollController;

  const BasicSegmentsListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.separatorBuilder,
    this.padding = EdgeInsets.zero,
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
        itemBuilder: itemBuilder,
        separatorBuilder: separatorBuilder,
        itemCount: items.length,
      ),
    );
  }
}

class SegmentsListView<T1 extends Segment, T2 extends Section> extends BasicSegmentsListView {
  SegmentsListView({
    super.key,
    required super.items,
    SegmentHeaderWidgetBuilder<T1> segmentBuilder = _defaultSegmentHeaderBuilder,
    required SectionWidgetBuilder<T2> sectionBuilder,
    super.padding,
    super.itemScrollController,
  }) : super(
          itemBuilder: (context, index) {
            final item = items[index];

            if (item is T1) {
              return KeyedSubtree(
                key: ValueKey(item.id),
                child: segmentBuilder(context, item),
              );
            }

            if (item is T2) {
              return KeyedSubtree(
                key: ValueKey(item.id),
                child: sectionBuilder(context, item),
              );
            }

            throw ArgumentError('Unknown item type[${item.runtimeType}]');
          },
          separatorBuilder: (context, index) {
            final item = items[index];

            if (item is T1) {
              return const SizedBox(height: 12);
            }

            if (item is T2) {
              return const SizedBox(height: 12);
            }

            throw ArgumentError('Unknown item type[${item.runtimeType}]');
          },
        );
}
