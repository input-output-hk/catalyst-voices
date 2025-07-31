import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:flutter/material.dart';

class VotingListUserSummary extends StatelessWidget {
  const VotingListUserSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: context.colors.elevationsOnSurfaceNeutralLv1Grey,
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Center(child: Text('Hi')),
        ),
      ),
    );
  }
}
