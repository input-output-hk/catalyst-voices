import 'package:catalyst_voices/widgets/buttons/voices_outlined_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class VoteListButton extends StatelessWidget {
  const VoteListButton({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedButton(
      leading: VoicesAssets.icons.vote.buildIcon(),
      child: Text(
        // TODO(dt-iohk): update count
        _getText(context, 10),
      ),
      onTap: () {
        // TODO(dt-iohk): handle vote list button
      },
    );
  }

  String _getText(BuildContext context, int count) {
    if (count == 0) {
      return context.l10n.voteListButton;
    } else {
      return '${context.l10n.voteListButton}· $count';
    }
  }
}
