import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class InsertNewImageDialogHeader extends StatelessWidget {
  const InsertNewImageDialogHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    const images = VoicesAssets.images;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: images.svg.insertImage.buildIcon(),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.insertNewImageDialogTitle,
                style: textTheme.headlineSmall,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.insertNewImageDialogDescription,
            style: textTheme.bodyLarge?.copyWith(
              color: colors.textOnPrimaryLevel1,
            ),
          ),
        ],
      ),
    );
  }
}
