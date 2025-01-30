import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/buttons/voices_segmented_button.dart';
import 'package:flutter/material.dart';

typedef MenuSegmentsButtons<T extends Object> = ({
  ButtonSegment<T> first,
  ButtonSegment<T> second,
});

class MenuSegmentsItemTile<T extends Object> extends StatelessWidget {
  final Widget title;
  final MenuSegmentsButtons<T> segments;
  final T? selected;
  final ValueChanged<T>? onChanged;

  const MenuSegmentsItemTile({
    super.key,
    required this.title,
    required this.segments,
    this.selected,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final onChanged = this.onChanged;

    return Container(
      constraints: const BoxConstraints.tightFor(height: 48),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _TitleDecoration(child: title)),
          const SizedBox(width: 8),
          VoicesSegmentedButton<T>(
            segments: [segments.first, segments.second],
            selected: {
              if (selected != null) selected!,
            },
            onChanged: onChanged != null
                ? (value) {
                    onChanged(value.single);
                  }
                : null,
            multiSelectionEnabled: false,
            emptySelectionAllowed: false,
            showSelectedIcon: false,
          ),
        ],
      ),
    );
  }
}

class _TitleDecoration extends StatelessWidget {
  final Widget child;

  const _TitleDecoration({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    final textStyle = (textTheme.bodyMedium ?? const TextStyle()).copyWith(
      color: context.colors.textOnPrimaryLevel0,
    );

    return DefaultTextStyle(
      style: textStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      child: child,
    );
  }
}
