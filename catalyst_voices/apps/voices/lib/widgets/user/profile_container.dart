import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class ProfileContainer extends StatelessWidget {
  final Profile profile;

  const ProfileContainer({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final username = profile.username;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        ProfileAvatar(
          size: 32,
          username: username,
        ),
        if (username != null)
          Text(
            username,
            style: context.textTheme.titleSmall?.copyWith(
              color: context.colors.textOnPrimaryLevel1,
            ),
          ),
        CatalystIdText(
          profile.catalystId,
          isCompact: true,
        ),
      ],
    );
  }
}
