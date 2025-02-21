import 'package:catalyst_voices/widgets/rich_text/voices_rich_text.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class VoicesRichTextLimit extends StatelessWidget {
  final VoicesRichTextController controller;
  final bool enabled;
  final int? charsLimit;
  final String? errorMessage;

  const VoicesRichTextLimit({
    super.key,
    required this.controller,
    this.enabled = true,
    this.charsLimit,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final error = errorMessage ?? '';

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: error.isEmpty ? 0 : 4,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              error,
              style: theme.textTheme.bodySmall!.copyWith(
                color: enabled
                    ? theme.colorScheme.error
                    : theme.colors.textDisabled,
              ),
            ),
          ),
          StreamBuilder(
            initialData: controller.markdownData.data.length,
            stream: controller.changes
                .map((e) => controller.markdownData.data.length)
                .distinct(),
            builder: (context, snapshot) {
              final data = snapshot.data;
              return Text(
                _formatText(data ?? 0),
                style: theme.textTheme.bodySmall,
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatText(int length) {
    final charsLimit = this.charsLimit;
    if (charsLimit == null) {
      return '';
    }

    return '$length/$charsLimit';
  }
}
