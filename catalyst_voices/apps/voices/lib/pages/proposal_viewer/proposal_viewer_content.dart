import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ProposalViewerContent extends StatelessWidget {
  final ItemScrollController scrollController;

  const ProposalViewerContent({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalViewerCubit, ProposalViewerState, bool>(
      selector: (state) => state.showData,
      builder: (context, state) {
        return Offstage(
          offstage: !state,
          child: _ProposalViewerContent(scrollController: scrollController),
        );
      },
    );
  }
}

class _ProposalViewerContent extends StatelessWidget {
  final ItemScrollController scrollController;

  const _ProposalViewerContent({
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: _SegmentsListenable(
        scrollController: scrollController,
      ),
    );
  }
}

class _SegmentsListenable extends StatelessWidget {
  final ItemScrollController scrollController;

  const _SegmentsListenable({
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: SegmentsControllerScope.of(context),
      builder: (context, value, child) {
        return _SegmentsListView(
          key: const ValueKey('ProposalViewerContentListView'),
          scrollController: scrollController,
          items: value.listItems,
        );
      },
    );
  }
}

class _SegmentsListView extends StatelessWidget {
  final ItemScrollController scrollController;
  final List<SegmentsListViewItem> items;

  const _SegmentsListView({
    super.key,
    required this.scrollController,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final readOnlyMode = context.select<ProposalViewerCubit, bool>(
      (cubit) => cubit.state.readOnlyMode,
    );

    return BasicSegmentsListView(
      key: const ValueKey('ProposalViewerSegmentsListView'),
      items: items,
      itemScrollController: scrollController,
      padding: EdgeInsets.only(top: readOnlyMode ? 150 : 56, bottom: 64),
      itemBuilder: (context, index) {
        final item = items[index];

        return Container(
          key: ValueKey('ProposalViewer.${item.id.value}.Tile'),
          padding: const EdgeInsets.all(16),
          child: _buildItem(context, item),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8);
      },
    );
  }

  Widget _buildItem(BuildContext context, SegmentsListViewItem item) {
    // For now, just show segment titles
    if (item is DocumentSegment) {
      return Text(
        item.resolveTitle(context),
        style: Theme.of(context).textTheme.headlineSmall,
      );
    }

    if (item is DocumentSection) {
      return Text(
        item.property.value.toString(),
        style: Theme.of(context).textTheme.bodyLarge,
      );
    }

    return const SizedBox.shrink();
  }
}
