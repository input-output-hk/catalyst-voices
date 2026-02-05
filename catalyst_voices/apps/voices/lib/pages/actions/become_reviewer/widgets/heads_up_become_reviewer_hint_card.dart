import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class HeadsUpBecomeReviewerHintCard extends StatelessWidget {
  const HeadsUpBecomeReviewerHintCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.tightFor(height: 118),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: context.colors.elevationsOnSurfaceNeutralLv1White,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: context.colors.dropShadow,
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.elevationsOnSurfaceNeutralLv1Grey,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          spacing: 2,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.l10n.verifyYourReviewerRegistration,
              style: context.textTheme.titleSmall?.copyWith(
                color: context.colors.textOnPrimaryLevel1,
              ),
            ),
            BulletList(
              items: [
                context.l10n.verifyYourReviewerRegistrationDescription1,
                context.l10n.verifyYourReviewerRegistrationDescription2,
              ],
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colors.textOnPrimaryLevel1,
              ),
              spacing: 2,
            ),
          ],
        ),
      ),
    );
  }
}
