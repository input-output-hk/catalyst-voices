import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/rich_text/placeholder_rich_text.dart';
import 'package:catalyst_voices/widgets/user/catalyst_id_text.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class InvitedByText extends StatelessWidget {
  final CatalystId? catalystId;

  const InvitedByText({super.key, this.catalystId});

  @override
  Widget build(BuildContext context) {
    if (catalystId != null) {
      return Row(
        spacing: 4,
        children: [
          PlaceholderRichText(
            context.l10n.invitedBy('{username}'),
            style: context.textTheme.labelMedium?.copyWith(
              color: context.colors.textOnPrimaryLevel1,
              fontWeight: FontWeight.w700,
            ),
            placeholderSpanBuilder: (context, placeholder) {
              return switch (placeholder) {
                'username' => TextSpan(
                  text: catalystId?.username,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.colors.textOnPrimaryLevel1,
                  ),
                ),
                _ => throw ArgumentError('Unknown placeholder', placeholder),
              };
            },
          ),
          CatalystIdText(
            catalystId!,
            isCompact: true,
            showCopy: false,
            showUsername: true,
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
