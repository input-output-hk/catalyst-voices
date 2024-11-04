import 'package:catalyst_voices/common/ext/ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SpaceOverviewHeader extends StatelessWidget {
  final Space space;

  const SpaceOverviewHeader(
    this.space, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          SpaceAvatar(space),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              space.localizedName(context.l10n),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colors.textOnPrimaryLevel0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
