import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class SeedPhrasePanel extends StatelessWidget {
  const SeedPhrasePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _Body(
            words: List.generate(12, (index) => 'word_$index'),
            onDownloadTap: () {},
          ),
        ),
        const SizedBox(height: 10),
        const _SeedPhraseStoredConfirmation(),
        const SizedBox(height: 10),
        const _Navigation(),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final List<String> words;
  final VoidCallback? onDownloadTap;

  const _Body({
    required this.words,
    this.onDownloadTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SeedPhrasesViewer(words: words),
          const SizedBox(height: 10),
          VoicesTextButton(
            onTap: onDownloadTap,
            child: Text(context.l10n.createKeychainSeedPhraseDownload),
          ),
        ],
      ),
    );
  }
}

class _SeedPhraseStoredConfirmation extends StatelessWidget {
  const _SeedPhraseStoredConfirmation();

  @override
  Widget build(BuildContext context) {
    return VoicesCheckbox(
      value: false,
      label: Text(context.l10n.createKeychainSeedPhraseStoreConfirmation),
      onChanged: (value) {},
    );
  }
}

class _Navigation extends StatelessWidget {
  final bool isNextEnabled;

  const _Navigation({
    this.isNextEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VoicesBackButton(
          onTap: () {
            RegistrationBloc.of(context).add(const PreviousStepEvent());
          },
        ),
        const SizedBox(width: 10),
        VoicesNextButton(
          onTap: isNextEnabled
              ? () => RegistrationBloc.of(context).add(const NextStepEvent())
              : null,
        ),
      ],
    );
  }
}
