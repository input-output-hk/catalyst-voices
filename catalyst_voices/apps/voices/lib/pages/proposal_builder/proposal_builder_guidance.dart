import 'package:catalyst_voices/widgets/document_builder/guidance/document_builder_guidance_list.dart';
import 'package:catalyst_voices/widgets/document_builder/guidance/document_builder_guidance_list_placeholder.dart';
import 'package:catalyst_voices/widgets/document_builder/guidance/document_builder_guidance_not_selected.dart';
import 'package:catalyst_voices/widgets/document_builder/guidance/document_builder_no_guidance.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class ProposalBuilderGuidanceSelector extends StatelessWidget {
  const ProposalBuilderGuidanceSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      identifier: 'ProposalBuilderGuidance',
      container: true,
      child:
          BlocSelector<
            ProposalBuilderBloc,
            ProposalBuilderState,
            ({bool isLoading, DocumentBuilderGuidance guidance})
          >(
            selector: (state) => (isLoading: state.isLoading, guidance: state.guidance),
            builder: (context, state) {
              if (state.isLoading) {
                return const DocumentBuilderGuidanceListPlaceholder();
              } else if (state.guidance.isNoneSelected) {
                return const DocumentBuilderGuidanceNotSelected();
              } else if (state.guidance.showEmptyState) {
                return const DocumentBuilderNoGuidance();
              } else {
                return DocumentBuilderGuidanceList(items: state.guidance.guidanceList);
              }
            },
          ),
    );
  }
}
