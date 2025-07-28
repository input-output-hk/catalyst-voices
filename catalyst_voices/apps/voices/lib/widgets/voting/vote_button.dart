import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

part 'vote_button_expanded.dart';
part 'vote_button_menu.dart';

const _expandedWidth = 294.0;

class VoteButton extends StatelessWidget {
  final VoteButtonData data;
  final ValueChanged<VoteType> onSelected;
  final VoidCallback? onRemove;

  const VoteButton({
    super.key,
    this.data = const VoteButtonData(),
    required this.onSelected,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final states = <WidgetState>{
      if (data.draft == null && data.casted != null) WidgetState.selected,
    };

    data.latestVoteType?.backgroundColor(context).resolve(states);
    data.latestVoteType?.foregroundColor(context).resolve(states);

    final backgroundColor = colors.background.resolve(states);
    final foregroundColor = colors.foreground.resolve(states);

    final textTheme = context.textTheme;
    final textStyle = (textTheme.labelLarge ?? const TextStyle()).copyWith(color: foregroundColor);
    final iconStyle = IconThemeData(size: 18, color: foregroundColor);

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8),
      child: DefaultTextStyle(
        style: textStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        child: IconTheme(
          data: iconStyle,
          child: _VoteButtonExpanded(
            data,
            onSelected: onSelected,
          ),
        ),
      ),
    );
  }
}
