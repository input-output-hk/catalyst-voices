import 'package:catalyst_voices/widgets/tiles/base_tile.dart';
import 'package:catalyst_voices/widgets/widgets.dart'
    show SegmentsController, SegmentsControllerScope;
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SectionBaseTile extends StatefulWidget {
  final NodeId id;
  final Widget child;

  const SectionBaseTile({
    super.key,
    required this.id,
    required this.child,
  });

  @override
  State<SectionBaseTile> createState() => _SectionBaseTileState();
}

class _SectionBaseTileState extends State<SectionBaseTile> {
  final _statesController = WidgetStatesController();
  SegmentsController? _segmentsController;

  @override
  Widget build(BuildContext context) {
    return BaseTile(
      statesController: _statesController,
      child: widget.child,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _segmentsController?.removeListener(_updateSelection);
    _segmentsController = SegmentsControllerScope.of(context);
    _segmentsController?.addListener(_updateSelection);

    _updateSelection();
  }

  @override
  void didUpdateWidget(covariant SectionBaseTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.id != oldWidget.id) {
      _updateSelection();
    }
  }

  @override
  void dispose() {
    _segmentsController?.removeListener(_updateSelection);
    _segmentsController = null;

    _statesController.dispose();

    super.dispose();
  }

  void _updateSelection() {
    final isSelected = _segmentsController?.value.activeSectionId == widget.id;

    _statesController.update(WidgetState.selected, isSelected);
  }
}
