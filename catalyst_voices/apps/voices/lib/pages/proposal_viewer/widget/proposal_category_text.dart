import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class ProposalCategoryText extends StatelessWidget {
  const ProposalCategoryText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalViewerCubit, ProposalViewerState, String?>(
      selector: (state) => state.data.categoryText,
      builder: (context, state) => Text(state ?? '-'),
    );
  }
}
