import 'dart:async';

import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/pages/actions/actions_shell_page.dart';
import 'package:catalyst_voices/pages/actions/representative/widgets/heads_up_representative_hint_card.dart';
import 'package:catalyst_voices/pages/actions/representative/widgets/representative_actions_instructions.dart';
import 'package:catalyst_voices/pages/actions/representative/widgets/representative_registration_status_card.dart';
import 'package:catalyst_voices/pages/actions/widgets/actions_header_text.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer_header.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/widgets.dart';

class RepresentativeActionPage extends StatefulWidget {
  const RepresentativeActionPage({super.key});

  @override
  State<RepresentativeActionPage> createState() => _RepresentativeActionPageState();
}

class _RepresentativeActionContent extends StatelessWidget {
  const _RepresentativeActionContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 22, bottom: 16),
          child: VoicesDrawerHeader(
            title: Text(context.l10n.becomeARepresentative),
            onCloseTap: () => ActionsShellPage.close(context),
            showBackButton: true,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              spacing: 20,
              children: [
                ActionsHeaderText(text: context.l10n.becomeReviewerActionHeaderText),
                const RepresentativeRegistrationStatusCard(),
                const RepresentativeActionsInstructions(),
                const RepresentativeAdditionalActions(),
              ],
            ),
          ),
        ),
        const HeadsUpRepresentativeHintCard(),
      ],
    );
  }
}

class _RepresentativeActionPageState extends State<RepresentativeActionPage> {
  late final RepresentativeActionCubit _cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: const _RepresentativeActionContent(),
    );
  }

  @override
  void dispose() {
    unawaited(_cubit.close());

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _cubit = Dependencies.instance.get<RepresentativeActionCubit>();
    _cubit.init();
  }
}
