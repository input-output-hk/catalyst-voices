part of 'vote_button.dart';

class _VoteButtonMenu extends StatelessWidget {
  final VoteTypeData? latest;
  final VoteTypeDataCasted? casted;

  const _VoteButtonMenu({
    this.latest,
    this.casted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.tightFor(width: _expandedWidth),
      decoration: BoxDecoration(
        color: context.colors.elevationsOnSurfaceNeutralLv1Grey,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            offset: const Offset(0, 2),
            blurRadius: 5,
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _VoteButtonMenuTypesRow(selected: latest),
          ...[
            if (latest?.isDraft ?? false) const _VoteButtonMenuRemoveFromVoteList(),
            if (casted case final VoteTypeDataCasted casted) _VoteButtonMenuCasted(data: casted),
          ].separatedBy(const _VoteButtonMenuDivider()).expandIndexed((index, element) {
            return [
              if (index == 0) const SizedBox(height: 8),
              element,
            ];
          }),
        ],
      ),
    );
  }
}

class _VoteButtonMenuCasted extends StatelessWidget {
  final VoteTypeDataCasted data;

  const _VoteButtonMenuCasted({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = (context.textTheme.labelLarge ?? const TextStyle()).copyWith(
      color: context.colors.textOnPrimaryLevel1,
    );

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Text(
            data.type.localisedName(context, present: false),
            style: textStyle,
            maxLines: 1,
          ),
          const Spacer(),
          TimestampText(
            data.castedAt,
            showTimezone: false,
            includeTime: false,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}

class _VoteButtonMenuDivider extends StatelessWidget {
  const _VoteButtonMenuDivider();

  @override
  Widget build(BuildContext context) {
    return const VoicesDivider(
      indent: 8,
      endIndent: 8,
      height: 8 * 2 + 1,
    );
  }
}

class _VoteButtonMenuRemoveFromVoteList extends StatelessWidget {
  const _VoteButtonMenuRemoveFromVoteList();

  @override
  Widget build(BuildContext context) {
    final textStyle = (context.textTheme.labelLarge ?? const TextStyle()).copyWith(
      color: context.colors.textOnPrimaryLevel0,
    );

    return Material(
      textStyle: textStyle,
      type: MaterialType.transparency,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () => Navigator.pop(context, const VoteButtonActionRemoveDraft()),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Text(
                context.l10n.removeFromVoteList,
                style: textStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              VoicesAssets.icons.x.buildIcon(
                size: 18,
                color: context.colors.iconsForeground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VoteButtonMenuTypesRow extends StatelessWidget {
  final VoteTypeData? selected;

  const _VoteButtonMenuTypesRow({
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(height: 74),
      child: Row(
        spacing: 6,
        children: VoteType.values
            .map<Widget>(
              (type) {
                return _VoteButtonMenuTypesRowButton(
                  type: type,
                  isCasted: selected?.isCasted ?? false,
                  isSelected: selected?.type == type,
                  onTap: () => Navigator.pop(context, VoteButtonActionVote(type)),
                );
              },
            )
            .map((child) => Expanded(child: child))
            .toList(),
      ),
    );
  }
}

class _VoteButtonMenuTypesRowButton extends StatefulWidget {
  final VoteType type;
  final bool isCasted;
  final bool isSelected;
  final VoidCallback onTap;

  const _VoteButtonMenuTypesRowButton({
    required this.type,
    required this.isCasted,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_VoteButtonMenuTypesRowButton> createState() => _VoteButtonMenuTypesRowButtonState();
}

class _VoteButtonMenuTypesRowButtonState extends State<_VoteButtonMenuTypesRowButton> {
  late final WidgetStatesController _statesController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final colors = theme.colors;

    final backgroundColor = VoteButtonBackgroundColor(
      voteType: widget.type,
      isCasted: widget.isCasted,
      colorScheme: colorScheme,
      colors: colors,
    );
    final foregroundColor = VoteButtonForegroundColor(
      voteType: widget.type,
      isCasted: widget.isCasted,
      colorScheme: colorScheme,
      colors: colors,
    );

    return ListenableBuilder(
      listenable: _statesController,
      builder: (context, child) {
        final effectiveBackgroundColor = backgroundColor.resolve(_statesController.value);
        final effectiveForegroundColor = foregroundColor.resolve(_statesController.value);

        final textStyle = (context.textTheme.labelLarge ?? const TextStyle())
            .copyWith(color: effectiveForegroundColor);
        final iconStyle = IconThemeData(size: 24, color: effectiveForegroundColor);

        return Material(
          color: effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          textStyle: textStyle,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(8),
            statesController: _statesController,
            child: IconTheme(
              data: iconStyle,
              child: child!,
            ),
          ),
        );
      },
      child: Column(
        spacing: 6,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          widget.type.icon().buildIcon(),
          Text(
            widget.type.localisedName(context),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(covariant _VoteButtonMenuTypesRowButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isSelected != oldWidget.isSelected) {
      _statesController.update(WidgetState.selected, widget.isSelected);
    }
  }

  @override
  void dispose() {
    _statesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _statesController = WidgetStatesController({
      if (widget.isSelected) WidgetState.selected,
    });
  }
}
