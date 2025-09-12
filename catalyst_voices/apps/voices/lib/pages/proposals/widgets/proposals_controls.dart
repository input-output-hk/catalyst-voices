import 'package:catalyst_voices/pages/proposals/widgets/category_selector.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_search.dart';
import 'package:flutter/material.dart';

class ProposalsControls extends StatelessWidget {
  const ProposalsControls({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        CategorySelector(),
        Flexible(child: ProposalsSearch()),
      ],
    );
  }
}
