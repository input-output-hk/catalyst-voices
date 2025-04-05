import 'package:catalyst_voices/pages/proposals/widgets/category_selector.dart';
import 'package:catalyst_voices/pages/proposals/widgets/proposals_search.dart';
import 'package:flutter/material.dart';

class ProposalsControls extends StatelessWidget {
  const ProposalsControls({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategorySelector(),
          SizedBox(width: 8),
          ProposalsSearch(),
        ],
      ),
    );
  }
}
