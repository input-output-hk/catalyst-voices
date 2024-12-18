import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef _StateData = ({bool show, LocalizedException? error});

class WorkspaceError extends StatelessWidget {
  const WorkspaceError({super.key});

  @override
  Widget build(BuildContext context) {
    return _Selector(
      builder: (context, state) {
        final message =
            state.error?.message(context) ?? context.l10n.somethingWentWrong;

        return Offstage(
          offstage: !state.show,
          child: Center(
            child: VoicesErrorIndicator(
              message: message,
              onRetry: () {
                const event = LoadProposalsEvent();
                context.read<WorkspaceBloc>().add(event);
              },
            ),
          ),
        );
      },
    );
  }
}

class _Selector extends StatelessWidget {
  final BlocWidgetBuilder<_StateData> builder;

  const _Selector({
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, _StateData>(
      selector: (state) => (show: state.showError, error: state.error),
      builder: builder,
    );
  }
}
