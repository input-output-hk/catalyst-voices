import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class WorkspaceError extends StatelessWidget {
  const WorkspaceError({super.key});

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: true,
      child: Center(
        child: VoicesErrorIndicator(
          message: 'Smth went wrong',
          onRetry: () {},
        ),
      ),
    );
  }
}
