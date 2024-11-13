import 'package:catalyst_voices/widgets/navigation/section_header.dart';
import 'package:catalyst_voices/widgets/navigation/section_step_offstage.dart';
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
    this.padding = const EdgeInsets.only(top: 10),
    this.itemScrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.separated(
      padding: padding?.resolve(Directionality.of(context)),
      itemScrollController: itemScrollController,
      itemBuilder: (context, index) {
        final item = items[index];

        if (item is T) {
          return SectionHeader(
            key: item.buildKey(),
            section: item,
          );
        }

        if (item is T2) {
          return SectionStepOffstage(
            key: item.buildKey(),
            sectionId: item.sectionId,
            child: stepBuilder(context, item),
          );
        }

        throw ArgumentError('Unknown section item type[${item.runtimeType}]');
      },
      separatorBuilder: (context, index) {
        // return const SizedBox(height: 12);
        // Or
        return const SizedBox(height: 24);
      },
      itemCount: items.length,
    );
  }
}

Widget _defaultHeaderBuilder(BuildContext context, Section section) {
  return SectionHeader(
    key: section.buildKey(),
    section: section,
  );
}
