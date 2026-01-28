import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:flutter/material.dart';

class ActionsHeaderText extends StatelessWidget {
  final String text;

  const ActionsHeaderText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.bodyMedium?.copyWith(
        color: context.colors.textOnPrimaryLevel1,
      ),
    );
  }
}
