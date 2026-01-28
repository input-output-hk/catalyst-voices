import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ActionsHeaderText extends StatelessWidget {
  const ActionsHeaderText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.myActionsPageHeader,
      style: context.textTheme.bodyMedium?.copyWith(
        color: context.colors.textOnPrimaryLevel1,
      ),
    );
  }
}
