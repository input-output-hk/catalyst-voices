import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProposalNavigationPanel extends StatelessWidget {
  const ProposalNavigationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (context, index) {
        if (index == 0) {
          return const _ControlsTile(key: ValueKey('NavigationControls'));
        }
        index--;

        return _SegmentMenuTile(
          key: ValueKey('Segment[$index]NodeMenu'),
          index: index,
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: 10 + 1,
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
  final int index;

  const _SegmentMenuTile({
    required super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesNodeMenu(
      name: 'Overview - ${index + 1}',
      icon: VoicesAssets.icons.lightningBolt.buildIcon(),
      onHeaderTap: () {},
      onItemTap: (id) {},
      selectedItemId: null,
      isExpanded: true,
      items: [
        VoicesNodeMenuItem(
          id: '$index.1',
          label: 'Metadata - ${index + 1}',
        ),
      ],
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
