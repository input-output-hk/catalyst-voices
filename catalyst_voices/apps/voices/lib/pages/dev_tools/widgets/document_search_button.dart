import 'package:catalyst_voices/pages/dev_tools/widgets/document_ref_field.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class DocumentSearchButton extends StatelessWidget {
  final VoidCallback onTap;
  final DocumentRefController refController;

  const DocumentSearchButton({
    super.key,
    required this.onTap,
    required this.refController,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: refController,
      builder: (context, value, _) {
        return _DocumentSearchButton(
          onTap: value != null ? onTap : null,
        );
      },
    );
  }
}

class _DocumentSearchButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _DocumentSearchButton({
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: onTap,
      child: const Text('Search'),
    );
  }
}
