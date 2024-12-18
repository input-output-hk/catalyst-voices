import 'package:catalyst_voices/widgets/indicators/voices_circular_progress_indicator.dart';
import 'package:flutter/material.dart';

class WorkspaceLoading extends StatelessWidget {
  const WorkspaceLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Offstage(
      offstage: true,
      child: TickerMode(
        enabled: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 32),
            child: VoicesCircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
