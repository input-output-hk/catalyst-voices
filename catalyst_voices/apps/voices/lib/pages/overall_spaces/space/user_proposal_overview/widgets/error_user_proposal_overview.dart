import 'package:catalyst_voices/widgets/indicators/voices_error_indicator.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ErrorProposalOverview extends StatelessWidget {
  const ErrorProposalOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, LocalizedException?>(
      selector: (state) => state.error,
      builder: (context, error) {
        return Offstage(
          offstage: error == null,
          child: _Error(error: error),
        );
      },
    );
  }
}

class _Error extends StatelessWidget {
  final LocalizedException? error;

  const _Error({
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: VoicesErrorIndicator(
        message: error?.message(context) ?? const LocalizedUnknownException().message(context),
        onRetry: () => context.read<WorkspaceBloc>().add(const WatchUserProposalsEvent()),
      ),
    );
  }
}
