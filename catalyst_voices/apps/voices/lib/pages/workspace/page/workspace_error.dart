import 'package:catalyst_voices/common/typedefs.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class WorkspaceErrorSelector extends StatelessWidget {
  const WorkspaceErrorSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, ErrorVisibilityState>(
      selector: (state) => (show: state.showError, data: state.error),
      builder: (context, state) {
        final errorMessage = state.data?.message(context);

        return Offstage(
          offstage: !state.show,
          child: _WorkspaceError(
            message: errorMessage ?? context.l10n.somethingWentWrong,
          ),
        );
      },
    );
  }
}

class _WorkspaceError extends StatelessWidget {
  final String message;

  const _WorkspaceError({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: VoicesErrorIndicator(
        message: message,
        onRetry: () {
          const event = WatchUserProposalsEvent();
          context.read<WorkspaceBloc>().add(event);
        },
      ),
    );
  }
}
