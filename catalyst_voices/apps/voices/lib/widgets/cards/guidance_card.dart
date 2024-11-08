import 'package:catalyst_voices/common/ext/guidance_ext.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class GuidanceCard extends StatelessWidget {
  final Guidance guidance;
  const GuidanceCard({
    super.key,
    required this.guidance,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colors.onSurfacePrimary08,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  guidance.type.icon.buildIcon(),
                  const SizedBox(width: 8),
                  Text(
                    _buildTypeTitle(context),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                guidance.title,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Theme.of(context).colors.textOnPrimary),
              ),
              const SizedBox(height: 10),
              Text(
                guidance.description,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildTypeTitle(BuildContext context) =>
      '${guidance.type.localizedType(context.l10n)} ${guidance.weightText}';
}
