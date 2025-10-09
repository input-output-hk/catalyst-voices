import 'package:catalyst_voices/widgets/indicators/voices_linear_progress_indicator.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class InfoContainer extends StatelessWidget {
  final String selectedFilename;
  final bool isUploading;

  const InfoContainer({
    super.key,
    required this.selectedFilename,
    required this.isUploading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colors.iconsPrimary),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        spacing: 16,
        children: [
          VoicesAssets.icons.documentAdd.buildIcon(
            color: Theme.of(context).colors.iconsPrimary,
            size: 30,
          ),
          if (isUploading)
            Expanded(
              child: Column(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.uploadProgressInfo,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const VoicesLinearProgressIndicator(),
                ],
              ),
            )
          else
            Text(
              selectedFilename,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
        ],
      ),
    );
  }
}
