import 'package:catalyst_voices/widgets/navigation/section_header.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

typedef SectionHeaderWidgetBuilder<T extends Section> = Widget Function(
  BuildContext context,
  T section,
);

typedef SectionStepWidgetBuilder<T extends SectionStep> = Widget Function(
  BuildContext context,
  T step,
);

class SectionsListView<T extends Section, T2 extends SectionStep>
    extends StatelessWidget {
  final List<SectionsListViewItem> items;
  final SectionHeaderWidgetBuilder<T> headerBuilder;
  final SectionStepWidgetBuilder<T2> stepBuilder;
  final EdgeInsetsGeometry? padding;
  final ItemScrollController? itemScrollController;

  const SectionsListView({
    super.key,
    required this.items,
    this.headerBuilder = _defaultHeaderBuilder,
    required this.stepBuilder,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
    this.itemScrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const _DisableOverscrollBehavior(),
      child: ScrollablePositionedList.separated(
        padding: padding?.resolve(Directionality.of(context)),
        itemScrollController: itemScrollController,
        itemBuilder: (context, index) {
          final item = items[index];

          if (item is T) {
            return KeyedSubtree(
              key: item.buildKey(),
              child: headerBuilder(context, item),
            );
          }

          if (item is T2) {
            return KeyedSubtree(
              key: item.buildKey(),
              child: stepBuilder(context, item),
            );
          }

          throw ArgumentError('Unknown section item type[${item.runtimeType}]');
        },
        separatorBuilder: (context, index) {
          final item = items[index];

          if (item is SectionStep) {
            return const SizedBox(height: 12);
          }

          return const SizedBox(height: 24);
        },
        itemCount: items.length,
      ),
    );
  }
}

Widget _defaultHeaderBuilder(BuildContext context, Section section) {
  return SectionHeader(
    section: section,
  );
}

/// Disables the iOS like overscroll behavior to avoid jumping UI.
///
// TODO(dtscalac): remove the workaround when
// https://github.com/google/flutter.widgets/issues/276 is fixed
class _DisableOverscrollBehavior extends ScrollBehavior {
  const _DisableOverscrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}
