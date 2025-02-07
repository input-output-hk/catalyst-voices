import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationBack extends StatelessWidget {
  final String? label;
  const NavigationBack({
    super.key,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          GoRouter.of(context).go(Routes.initialLocation);
        }
      },
      behavior: HitTestBehavior.translucent,
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(height: 40),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            VoicesAssets.icons.arrowLeft.buildIcon(
              size: 18,
              color: context.colors.textOnPrimaryLevel1,
            ),
            const SizedBox(width: 8),
            Text(
              label ?? context.l10n.back,
              style: context.textTheme.labelLarge?.copyWith(
                color: context.colors.textOnPrimaryLevel1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
