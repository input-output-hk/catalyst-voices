import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ProposalBuilderSegmentsSelector extends StatelessWidget {
  final ItemScrollController itemScrollController;

  const ProposalBuilderSegmentsSelector({
    super.key,
    required this.itemScrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalBuilderBloc, ProposalBuilderState, bool>(
      selector: (state) => state.showSegments,
      builder: (context, state) {
        return Offstage(
          offstage: !state,
          child: _ProposalBuilderSegments(
            itemScrollController: itemScrollController,
          ),
        );
      },
    );
  }
}

class _ProposalBuilderSegments extends StatelessWidget {
  final ItemScrollController itemScrollController;

  const _ProposalBuilderSegments({
    required this.itemScrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentsListViewBuilder(
      builder: (context, value, child) {
        return SegmentsListView<ProposalBuilderSegment, ProposalBuilderSection>(
          itemScrollController: itemScrollController,
          items: value,
          padding: const EdgeInsets.only(top: 16, bottom: 64),
          sectionBuilder: (context, data) {
            return DocumentBuilderSectionTile(
              key: key,
              section: data.documentSection,
              onChanged: (value) {
                final event = SectionChangedEvent(changes: value);
                context.read<ProposalBuilderBloc>().add(event);
              },
            );
          },
        );
      },
    );
  }
}
