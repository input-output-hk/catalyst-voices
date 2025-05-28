import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/list/voices_list.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class CategoryRequirementsList extends StatelessWidget {
  final List<String> dos;
  final List<String> donts;

  const CategoryRequirementsList({
    super.key,
    required this.dos,
    required this.donts,
  });

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: dos.isEmpty && donts.isEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Text(
            context.l10n.categoryRequirements,
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          if (dos.isNotEmpty)
            VoicesList(
              items: dos,
              icon: VoicesAssets.icons.check.buildIcon(color: context.colors.iconsPrimary),
            ),
          if (donts.isNotEmpty) ...[
            const SizedBox(height: 12),
            VoicesList(
              items: donts,
              icon: VoicesAssets.icons.x.buildIcon(color: context.colors.iconsPrimary),
            ),
          ],
        ],
      ),
    );
  }
}
