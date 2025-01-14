import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProposalBuilderErrorSelector extends StatelessWidget {
  final VoidCallback onRetryTap;

  const ProposalBuilderErrorSelector({
    super.key,
    required this.onRetryTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalBuilderBloc, ProposalBuilderState,
        LocalizedException?>(
      selector: (state) => state.showError ? state.error : null,
      builder: (context, state) {
        final errorMessage = state?.message(context);

        return Offstage(
          offstage: errorMessage == null,
          child: _ProposalBuilderError(
            message: errorMessage ?? context.l10n.somethingWentWrong,
            onRetryTap: onRetryTap,
          ),
        );
      },
    );
  }
}

class _ProposalBuilderError extends StatelessWidget {
  final String message;
  final VoidCallback onRetryTap;

  const _ProposalBuilderError({
    required this.message,
    required this.onRetryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: VoicesErrorIndicator(
        message: message,
        onRetry: onRetryTap,
      ),
    );
  }
}
