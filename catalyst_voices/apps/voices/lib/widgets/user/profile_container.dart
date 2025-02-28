import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class ProfileContainer extends StatelessWidget {
  final Profile profile;

  const ProfileContainer({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = profile.displayName;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        VoicesAvatar(
          radius: 32 / 2,
          icon: Text(
            displayName?.firstLetter?.capitalize() ?? '',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
        ),
        if (displayName != null)
          Text(
            displayName,
            style: context.textTheme.titleSmall?.copyWith(
              color: context.colors.textOnPrimaryLevel1,
            ),
          ),
        CatalystIdText(
          profile.catalystId,
          isCompact: true,
        ),
      ].separatedBy(const SizedBox(width: 8)).toList(),
    );
  }
}
