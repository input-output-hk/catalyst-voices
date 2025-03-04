import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProposalNavigationPanel extends StatelessWidget {
  const ProposalNavigationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: SegmentsControllerScope.of(context),
      builder: (context, value, _) {
        return _ProposalNavigationPanel(
          segments: value.segments,
          openedSegments: value.openedSegments,
          selectedSectionId: value.activeSectionId,
        );
      },
    );
  }
}

class _ProposalNavigationPanel extends StatelessWidget {
  final List<Segment> segments;
  final Set<NodeId> openedSegments;
  final NodeId? selectedSectionId;

  const _ProposalNavigationPanel({
    required this.segments,
    this.openedSegments = const {},
    this.selectedSectionId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (context, index) {
        if (index == 0) {
          return const _ControlsTile(key: ValueKey('NavigationControls'));
        }

        final segment = segments[index - 1];

        return _SegmentMenuTile(
          key: ValueKey('Segment[$index]NodeMenu'),
          segment: segment,
          isExpanded: openedSegments.contains(segment.id),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: segments.length + 1,
    );
  }
}

class _ControlsTile extends StatelessWidget {
  const _ControlsTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bottomBorder = BorderSide(
      color: context.colors.outlineBorderVariant,
    );

    return Container(
      decoration: BoxDecoration(border: Border(bottom: bottomBorder)),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          VoicesIconButton(
            onTap: () {
              // TODO(damian-molinski): Implement toggling panel
            },
            child: VoicesAssets.icons.leftRailToggle.buildIcon(),
          ),
          const Spacer(),
          const _VersionSelector(),
        ],
      ),
    );
  }
}

class _SegmentMenuTile extends StatelessWidget {
  final Segment segment;
  final bool isExpanded;

  const _SegmentMenuTile({
    required super.key,
    required this.segment,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesNodeMenu(
      key: ValueKey('Segment[${segment.id}]NodeMenu'),
      name: segment.resolveTitle(context),
      icon: segment.icon.buildIcon(),
      onHeaderTap: () {
        SegmentsControllerScope.of(context).toggleSegment(segment.id);
      },
      onItemTap: (id) {
        final sections = segment.sections;
        final section = sections.firstWhere((e) => e.id.value == id);

        SegmentsControllerScope.of(context).selectSectionStep(section.id);
      },
      selectedItemId: null,
      isExpanded: isExpanded,
      items: segment.sections.map(
        (section) {
          return VoicesNodeMenuItem(
            id: section.id.value,
            label: section.resolveTitle(context),
            isEnabled: section.isEnabled,
            hasError: section.hasError,
          );
        },
      ).toList(),
    );
  }
}

class _VersionSelector extends StatelessWidget {
  const _VersionSelector();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalBloc, ProposalState, DocumentVersions>(
      selector: (state) => state.data.header.versions,
      builder: (context, state) {
        return DocumentVersionSelector(
          current: state.current,
          versions: state.all,
          showBorder: false,
        );
      },
    );
  }
}
