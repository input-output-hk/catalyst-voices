import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/avatars/voices_avatar.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class VoicesLeadingIconCard extends StatelessWidget {
  final SvgGenImage icon;
  final Widget child;

  const VoicesLeadingIconCard({
    super.key,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.elevationsOnSurfaceNeutralLv1White,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: VoicesAvatar(
                backgroundColor: context.colors.onSurfacePrimary08,
                icon: icon.buildIcon(),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
            child: child,
          ),
        ],
      ),
    );
  }
}
