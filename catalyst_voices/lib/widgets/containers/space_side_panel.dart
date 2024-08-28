import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class SpaceSidePanel extends StatelessWidget {
  final bool isLeft;
  final EdgeInsetsGeometry margin;

  const SpaceSidePanel({
    super.key,
    required this.isLeft,
    this.margin = const EdgeInsets.only(top: 10),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: theme.colors.onSurfaceNeutralOpaqueLv0,
        borderRadius: isLeft
            ? const BorderRadius.horizontal(right: Radius.circular(16))
            : const BorderRadius.horizontal(left: Radius.circular(16)),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Header(name: 'Campaign builder'),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String name;

  const _Header({
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints.tightFor(height: 56),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const VoicesIconButton(
            child: Icon(CatalystVoicesIcons.arrow_narrow_left),
          ),
          Flexible(
            child: Text(
              'Campaign builder',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colors.textOnPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
