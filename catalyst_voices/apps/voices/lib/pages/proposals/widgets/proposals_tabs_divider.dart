import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProposalsTabsDivider extends StatelessWidget {
  const ProposalsTabsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: MediaQuery.sizeOf(context).width < 1400,
      child: VoicesDivider(
        height: 1,
        color: context.colors.primaryContainer,
      ),
    );
  }
}
