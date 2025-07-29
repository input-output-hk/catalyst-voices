import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:flutter/material.dart';

class VotingListUserSummary extends StatelessWidget {
  const VotingListUserSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: 58,
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: context.colors.elevationsOnSurfaceNeutralLv1Grey,
          child: Center(child: Text('Hi')),
        ),
      ),
    );
  }
}
