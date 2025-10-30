import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/share/share_manager.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class CopyCatalystIdTip extends StatelessWidget {
  const CopyCatalystIdTip({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, bool>(
      selector: (state) => state.isActive,
      builder: (context, isActive) {
        return Offstage(
          offstage: !isActive,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: TipText(
              context.l10n.tipCopyCatalystIdForReviewTool(
                ShareManager.of(context).becomeReviewer().decoded(),
              ),
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.textOnPrimaryLevel1,
              ),
            ),
          ),
        );
      },
    );
  }
}
