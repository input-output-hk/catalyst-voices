import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class DocumentsCountText extends StatelessWidget {
  const DocumentsCountText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DevToolsBloc, DevToolsState, int>(
      selector: (state) => state.documentsCount ?? 0,
      builder: (context, state) => _DocumentsCountText(state),
    );
  }
}

class _DocumentsCountText extends StatelessWidget {
  final int data;

  const _DocumentsCountText(this.data);

  @override
  Widget build(BuildContext context) {
    return Text('$data');
  }
}
