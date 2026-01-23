import 'package:catalyst_voices/widgets/document_builder/layout/document_builder_content_error.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalBuilderErrorSelector extends StatelessWidget {
  final VoidCallback onRetryTap;

  const ProposalBuilderErrorSelector({
    super.key,
    required this.onRetryTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalBuilderBloc, ProposalBuilderState, LocalizedException?>(
      selector: (state) => state.showError ? state.error : null,
      builder: (context, state) {
        final errorMessage = state?.message(context);

        return Offstage(
          offstage: errorMessage == null,
          child: DocumentBuilderContentError(
            message: errorMessage ?? '',
            onRetryTap: onRetryTap,
          ),
        );
      },
    );
  }
}
