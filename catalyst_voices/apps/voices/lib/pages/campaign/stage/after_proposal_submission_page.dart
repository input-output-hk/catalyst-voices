import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/campaign/stage/background.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class AfterProposalSubmissionPage extends StatelessWidget {
  const AfterProposalSubmissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeBuilder.buildTheme(),
      child: Background(
        child: ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 560),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CatalystImage.asset(VoicesAssets.images.thanks.path),
              const SizedBox(height: 17),
              const _Header(),
              const SizedBox(height: 35),
              const _Description(),
              const SizedBox(height: 24),
              const _ActionButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton();

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        // TODO(LynxLynxx): implement url launching
      },
      child: Text(context.l10n.learnMore),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.proposalSubmissionClosedDescription,
      style: context.textTheme.bodyLarge,
      textAlign: TextAlign.center,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.proposalSubmissionIsClosed,
      style: context.textTheme.displaySmall,
      textAlign: TextAlign.center,
    );
  }
}
