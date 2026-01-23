import 'package:catalyst_voices/widgets/document_builder/layout/document_builder_content_placeholder.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class ProposalBuilderLoadingSelector extends StatelessWidget {
  const ProposalBuilderLoadingSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalBuilderBloc, ProposalBuilderState, bool>(
      selector: (state) => state.isLoading,
      builder: (context, isLoading) => DocumentBuilderContentPlaceholder(show: isLoading),
    );
  }
}
