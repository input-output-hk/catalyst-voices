import 'dart:async';

import 'package:catalyst_voices/app/view/app_splash_screen_manager.dart';
import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/campaign/stage/campaign_background.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AfterProposalSubmissionPage extends StatefulWidget {
  const AfterProposalSubmissionPage({super.key});

  @override
  State<AfterProposalSubmissionPage> createState() =>
      _AfterProposalSubmissionPageState();
}

class _ActionButton extends StatelessWidget with LaunchUrlMixin {
  const _ActionButton();

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () async {
        await launchUri(VoicesConstants.afterSubmissionUrl.getUri());
      },
      child: Text(context.l10n.learnMore),
    );
  }
}

class _AfterProposalSubmissionPageState
    extends State<AfterProposalSubmissionPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<CampaignStageCubit, CampaignStageState>(
      listener: (context, state) {
        if (state is! AfterProposalSubmissionStage) {
          const DiscoveryRoute().go(context);
        } else if (state is LoadingCampaignStage) {
          return;
        }
        AppSplashScreenManager.hideSplashScreen();
      },
      child: Theme(
        data: ThemeBuilder.buildTheme(),
        child: CampaignBackground(
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
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    AppSplashScreenManager.preserveSplashScreen(widgetsBinding);
    unawaited(context.read<CampaignStageCubit>().getCampaignStage());
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
