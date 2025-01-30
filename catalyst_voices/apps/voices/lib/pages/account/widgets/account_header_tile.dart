import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/avatars/voices_avatar.dart';
import 'package:catalyst_voices/widgets/text/catalyst_id_text.dart';
import 'package:flutter/material.dart';

class AccountHeaderTile extends StatelessWidget {
  const AccountHeaderTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VoicesAvatar(
          radius: 155 / 2,
          icon: Text(
            'T',
            style: TextStyle(
              fontSize: 92,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
        ),
        SizedBox(width: 24),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tyler',
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.colors.textOnPrimaryLevel0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 16),
              CatalystIdText(
                'cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE',
                isCompact: false,
                backgroundColor: context.colors.onSurfaceNeutralOpaqueLv2,
              ),
            ],
          ),
        )
      ],
    );
  }
}
