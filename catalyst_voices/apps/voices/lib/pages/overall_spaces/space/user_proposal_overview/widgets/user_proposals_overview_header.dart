import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:flutter/material.dart';

class UserProposalsOverviewHeader extends StatelessWidget {
  final String title;

  const UserProposalsOverviewHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        top: 18,
        bottom: 18,
      ),
      child: Text(
        title,
        style: context.textTheme.titleMedium?.copyWith(
          color: context.colors.textOnPrimaryLevel1,
        ),
      ),
    );
  }
}
