import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ProposalBack extends StatelessWidget {
  const ProposalBack({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBack(
      label: context.l10n.backToList,
      padding: const EdgeInsets.all(8),
    );
  }
}
