import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class PropertyTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Widget? action;
  final Widget? footer;
  final Widget child;

  const PropertyTile({
    super.key,
    required this.title,
    this.isSelected = false,
    this.action,
    this.footer,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final footer = this.footer;

    return SelectableTile(
      isSelected: isSelected,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints.tightFor(height: 44),
              child: _Header(
                title: title,
                action: action,
              ),
            ),
            const SizedBox(height: 12),
            child,
            if (footer != null) ...[
              const SizedBox(height: 24),
              footer,
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final Widget? action;

  const _Header({
    required this.title,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final action = this.action;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        if (action != null) ...[
          const SizedBox(width: 16),
          action,
        ],
      ],
    );
  }
}
