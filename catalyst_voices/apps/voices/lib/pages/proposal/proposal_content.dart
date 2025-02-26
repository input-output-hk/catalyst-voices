import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ProposalContent extends StatelessWidget {
  final ItemScrollController controller;

  const ProposalContent({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 16, bottom: 64),
      itemBuilder: (context, index) {
        final isFirst = index == 0;
        final isLast = index == 199;

        return Container(
          key: ValueKey('Section${index}Key'),
          constraints: const BoxConstraints(minHeight: 100),
          decoration: BoxDecoration(
            color: context.colors.elevationsOnSurfaceNeutralLv0,
            borderRadius: BorderRadius.vertical(
              top: isFirst ? const Radius.circular(16) : Radius.zero,
              bottom: isLast ? const Radius.circular(16) : Radius.zero,
            ),
          ),
          alignment: Alignment.center,
          child: Text('Segment nr. ${index + 1}'),
        );
      },
      separatorBuilder: (_, __) => const VoicesDivider.expanded(height: 1),
      itemCount: 200,
    );
  }
}
