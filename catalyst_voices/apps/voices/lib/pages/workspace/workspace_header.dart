import 'package:catalyst_voices/common/ext/space_ext.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class WorkspaceHeader extends StatelessWidget {
  const WorkspaceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32),
            _TitleText(),
            SizedBox(height: 48),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SubtitleText(),
                      SizedBox(height: 16),
                      _DescriptionText(),
                      SizedBox(height: 32),
                      _DraftProposalButton(),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _SearchTextField(),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _Tabs(),
          ],
        ),
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      Space.workspace.localizedName(context.l10n),
      style: theme.textTheme.headlineLarge?.copyWith(
        color: theme.colorScheme.primary,
      ),
    );
  }
}

class _SubtitleText extends StatelessWidget {
  const _SubtitleText();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      context.l10n.myProposals,
      style: theme.textTheme.displaySmall?.copyWith(
        color: theme.colors.textOnPrimaryLevel0,
      ),
    );
  }
}

class _DescriptionText extends StatelessWidget {
  const _DescriptionText();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      context.l10n.workspaceDescription,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colors.textOnPrimaryLevel0,
      ),
    );
  }
}

class _DraftProposalButton extends StatelessWidget {
  const _DraftProposalButton();

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: () {
        // TODO(damian-molinski): implement pushing editor.
      },
      leading: VoicesAssets.icons.plus.buildIcon(),
      child: Text(context.l10n.newDraftProposal),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        onTap: (index) {
          // TODO(damian-molinski): implement event emit.
        },
        tabs: [
          Tab(text: context.l10n.draftProposalsX(0)),
          Tab(text: context.l10n.finalProposalsX(1)),
        ],
      ),
    );
  }
}

class _SearchTextField extends StatelessWidget {
  const _SearchTextField();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 372),
      child: VoicesTextField(
        decoration: VoicesTextFieldDecoration(
          labelText: context.l10n.searchProposals,
          hintText: context.l10n.search,
          prefixIcon: VoicesAssets.icons.search.buildIcon(),
          filled: true,
        ),
        keyboardType: TextInputType.text,
        onFieldSubmitted: (value) {},
        onChanged: (value) {},
      ),
    );
  }
}
