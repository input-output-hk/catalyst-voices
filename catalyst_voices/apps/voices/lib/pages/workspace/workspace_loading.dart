import 'package:catalyst_voices/widgets/indicators/voices_circular_progress_indicator.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkspaceLoading extends StatelessWidget {
  const WorkspaceLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return _Selector(
      builder: (context, state) {
        return Offstage(
          offstage: !state,
          child: TickerMode(
            enabled: state,
            child: const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 32),
                child: VoicesCircularProgressIndicator(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Selector extends StatelessWidget {
  final BlocWidgetBuilder<bool> builder;

  const _Selector({
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, bool>(
      selector: (state) => state.isLoading,
      builder: builder,
    );
  }
}
