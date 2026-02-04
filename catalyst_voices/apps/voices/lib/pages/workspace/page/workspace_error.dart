import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class WorkspaceError extends StatelessWidget {
  const WorkspaceError({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, LocalizedException?>(
      selector: (state) => state.error,
      builder: (context, error) {
        final errorMessage = error?.message(context);

        return Offstage(
          offstage: error == null,
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
          const event = ChangeWorkspaceFilters();
          context.read<WorkspaceBloc>().add(event);
        },
      ),
    );
  }
}
