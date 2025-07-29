import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:flutter/material.dart';

class VotingListFooter extends StatelessWidget {
  const VotingListFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.onSurfaceNeutralOpaqueLv0,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      padding: const EdgeInsets.all(24).subtract(const EdgeInsets.only(top: 8)),
      alignment: Alignment.center,
      child: Text('Footer'),
    );
  }
}
