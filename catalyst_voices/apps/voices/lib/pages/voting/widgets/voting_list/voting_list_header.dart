import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class VotingListHeader extends StatelessWidget {
  const VotingListHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 12, 4),
      child: Row(
        children: [
          const _TitleText(),
          const Spacer(),
          XButton(onTap: () => Scaffold.of(context).closeEndDrawer()),
        ],
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.voteList,
      style: context.textTheme.titleLarge?.copyWith(color: context.colors.textOnPrimaryLevel0),
    );
  }
}
