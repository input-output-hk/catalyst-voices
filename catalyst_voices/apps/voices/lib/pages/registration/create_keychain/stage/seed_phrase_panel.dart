import 'dart:async';

import 'package:catalyst_voices/pages/registration/widgets/export_catalyst_key_confirm_dialog.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_navigation.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SeedPhrasePanel extends StatefulWidget {
  const SeedPhrasePanel({
    super.key,
  });

  @override
  State<SeedPhrasePanel> createState() => _SeedPhrasePanelState();
}

class _SeedPhrasePanelState extends State<SeedPhrasePanel> {
  @override
  void initState() {
    super.initState();
    RegistrationCubit.of(context).keychainCreation.buildSeedPhrase();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _BlocLoadable(
            builder: (context) => const _BlocSeedPhraseWords(),
          ),
        ),
        const SizedBox(height: 10),
        const _BlocStoredCheckbox(),
        const SizedBox(height: 10),
        const _BlocNavigation(),
      ],
    );
  }
}

class _BlocLoadable extends StatelessWidget {
  final WidgetBuilder builder;

  const _BlocLoadable({
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSeedPhraseSelector<bool>(
      selector: (state) => state.isLoading,
      builder: (context, state) {
        return VoicesLoadable(
          isLoading: state,
          builder: builder,
        );
      },
    );
  }
}

class _BlocSeedPhraseWords extends StatelessWidget {
  const _BlocSeedPhraseWords();

  @override
  Widget build(BuildContext context) {
    return BlocSeedPhraseSelector<List<SeedPhraseWord>>(
      selector: (state) => state.seedPhraseWords,
      builder: (context, state) => _SeedPhraseWords(state),
    );
  }
}

class _SeedPhraseWords extends StatelessWidget {
  final List<SeedPhraseWord> words;

  const _SeedPhraseWords(this.words);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          SeedPhrasesViewer(words: words),
          const SizedBox(height: 10),
          VoicesTextButton(
            key: const Key('DownloadSeedPhraseButton'),
            onTap: () => unawaited(_exportSeedPhrase(context)),
            child: Text(context.l10n.createKeychainSeedPhraseExport),
          ),
        ],
      ),
    );
  }

  Future<void> _exportSeedPhrase(BuildContext context) async {
    final confirmed = await ExportCatalystKeyConfirmDialog.show(context);

    if (confirmed && context.mounted) {
      await RegistrationCubit.of(context).keychainCreation.exportSeedPhrase();
    }
  }
}

class _BlocStoredCheckbox extends StatelessWidget {
  const _BlocStoredCheckbox();

  @override
  Widget build(BuildContext context) {
    return BlocSeedPhraseSelector<bool>(
      selector: (state) => state.isStoredConfirmed,
      builder: (context, state) {
        return _StoredCheckbox(
          isConfirmed: state,
        );
      },
    );
  }
}

class _StoredCheckbox extends StatelessWidget {
  final bool isConfirmed;

  const _StoredCheckbox({
    this.isConfirmed = false,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesCheckbox(
      key: const Key('SeedPhraseStoredCheckbox'),
      value: isConfirmed,
      label: Text(context.l10n.createKeychainSeedPhraseStoreConfirmation),
      onChanged: (value) {
        RegistrationCubit.of(context)
            .keychainCreation
            .setSeedPhraseStored(value);
      },
    );
  }
}

class _BlocNavigation extends StatelessWidget {
  const _BlocNavigation();

  @override
  Widget build(BuildContext context) {
    return BlocSeedPhraseSelector<bool>(
      selector: (state) => state.isStoredConfirmed,
      builder: (context, state) {
        return RegistrationBackNextNavigation(
          isNextEnabled: state,
        );
      },
    );
  }
}
