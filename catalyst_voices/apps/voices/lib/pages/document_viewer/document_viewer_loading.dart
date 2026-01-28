import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class DocumentViewerLoading extends StatelessWidget {
  const DocumentViewerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DocumentViewerCubit, DocumentViewerState, bool>(
      selector: (state) => state.isLoading,
      builder: (context, state) {
        return Offstage(
          offstage: !state,
          child: TickerMode(
            enabled: state,
            child: const _DocumentViewerLoading(),
          ),
        );
      },
    );
  }
}

class _DocumentViewerLoading extends StatelessWidget {
  const _DocumentViewerLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: VoicesCircularProgressIndicator());
  }
}
