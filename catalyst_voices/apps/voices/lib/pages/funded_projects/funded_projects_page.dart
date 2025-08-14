import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class FundedProjectsPage extends StatelessWidget {
  const FundedProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      children: [
        const SizedBox(height: 44),
        Text(
          context.l10n.fundedProjectSpace,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ],
    );
  }
}
