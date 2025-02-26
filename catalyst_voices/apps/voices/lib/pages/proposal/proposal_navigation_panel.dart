import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class ProposalNavigationPanel extends StatelessWidget {
  const ProposalNavigationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (context, index) {
        if (index == 0) {
          return const _NavigationControls(key: ValueKey('NavigationControls'));
        }
        index--;

        return VoicesNodeMenu(
          key: ValueKey('Segment[$index]NodeMenu'),
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
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: 10 + 1,
    );
  }
}

class _NavigationControls extends StatelessWidget {
  const _NavigationControls({
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
            onTap: () {},
            child: VoicesAssets.icons.leftRailToggle.buildIcon(),
          ),
          const Spacer(),
          DocumentVersionSelector(
            current: '1',
            versions: ['1', '2'],
            showBorder: false,
          ),
        ],
      ),
    );
  }
}
