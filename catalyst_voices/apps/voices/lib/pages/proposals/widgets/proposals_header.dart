import 'package:catalyst_voices/pages/proposals/widgets/proposals_fund_info.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProposalsHeader extends StatelessWidget {
  const ProposalsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        NavigationBack(),
        SizedBox(height: 40),
        ProposalsFundInfo(),
      ],
    );
  }
}
