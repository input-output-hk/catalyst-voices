import 'package:catalyst_voices/widgets/indicators/voices_loading_overlay.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkspaceLoadingSelector extends StatelessWidget {
  final Widget child;

  const WorkspaceLoadingSelector({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, bool>(
      selector: (state) => state.isLoading,
      builder: (context, isLoading) {
        return Stack(
          children: [
            child,
            VoicesLoadingOverlay(show: isLoading),
          ],
        );
      },
    );
  }
}
