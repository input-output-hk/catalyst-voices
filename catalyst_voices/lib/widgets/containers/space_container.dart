import 'package:catalyst_voices/widgets/containers/space_side_panel.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class SpaceContainer extends StatelessWidget {
  const SpaceContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TracksContainer(
      leftRail: SpaceSidePanel(
        key: ValueKey('LeftSpacePanelKey'),
        isLeft: true,
      ),
      rightRail: SpaceSidePanel(
        key: ValueKey('RightSpacePanelKey'),
        isLeft: false,
      ),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        itemBuilder: (context, index) {
          if (index.isOdd) return const SizedBox(height: 16);

          return Container(
            height: 128,
            decoration: BoxDecoration(
              color: Theme.of(context).colors.onSurfaceNeutralOpaqueLv0,
              borderRadius: BorderRadius.circular(28),
            ),
            alignment: Alignment.center,
            child: Text(index.toString()),
          );
        },
      ),
    );
  }
}
