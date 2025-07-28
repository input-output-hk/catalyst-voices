part of 'vote_button.dart';

class _VoteButtonMenu extends StatelessWidget {
  final VoteType? selected;

  const _VoteButtonMenu({
    this.selected,
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
          _VoteButtonMenuTypesRow(selected: selected),
          const SizedBox(height: 8),
          const VoicesDivider(
            indent: 8,
            endIndent: 8,
            height: 8 * 2 + 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text('Voted Yes'),
          ),
        ],
      ),
    );
  }
}

class _VoteButtonMenuTypesRow extends StatelessWidget {
  final VoteType? selected;

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
                  isSelected: type == selected,
                  onTap: () => Navigator.pop(context, type),
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
  final bool isSelected;
  final VoidCallback onTap;

  const _VoteButtonMenuTypesRowButton({
    required this.type,
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
    final textStyle = (context.textTheme.labelLarge ?? const TextStyle())
        .copyWith(color: context.colors.textOnPrimaryLevel0);
    final iconStyle = IconThemeData(size: 24, color: context.colors.iconsForeground);

    return ListenableBuilder(
      listenable: _statesController,
      builder: (context, child) {
        return Material(
          color: context.colors.onSurfaceNeutral08,
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
