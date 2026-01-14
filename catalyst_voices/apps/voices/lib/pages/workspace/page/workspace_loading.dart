import 'package:catalyst_voices/widgets/indicators/voices_loading_overlay.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class WorkspaceLoading extends StatelessWidget {
  final Widget child;

  const WorkspaceLoading({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, bool>(
      selector: (state) => state.isLoading,
      builder: (context, isLoading) {
        return _LoadingStack(
          isLoading: isLoading,
          child: child,
        );
      },
    );
  }
}

class _LoadingStack extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const _LoadingStack({
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        VoicesLoadingOverlay(show: isLoading),
      ],
    );
  }
}
