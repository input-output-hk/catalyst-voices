import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer_header.dart';
import 'package:flutter/material.dart';

class CoProposersConsentPage extends StatelessWidget {
  const CoProposersConsentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VoicesDrawerHeader(
          text: 'Co-Proposer Display Consent',
          onCloseTap: Scaffold.of(context).closeEndDrawer,
          showBackButton: true,
        ),
        const SizedBox(height: 30),
        const _Content(),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          'No actions',
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
          ),
        ),
      ),
    );
  }
}
