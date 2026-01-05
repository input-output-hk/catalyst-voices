import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VoicesDrawerHeader extends StatelessWidget {
  final VoidCallback? onCloseTap;
  final bool showBackButton;
  final String text;

  const VoicesDrawerHeader({
    super.key,
    required this.text,
    this.showBackButton = false,
    this.onCloseTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBackButton)
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: context.pop,
          ),
        Expanded(
          child: Text(
            text,
            style: context.textTheme.titleLarge,
          ),
        ),
        CloseButton(
          onPressed: onCloseTap != null ? onCloseTap!.call : Navigator.maybeOf(context)?.pop,
          style: IconButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
