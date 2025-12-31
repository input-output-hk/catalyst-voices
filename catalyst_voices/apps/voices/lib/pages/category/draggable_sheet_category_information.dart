import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/category/widgets/card_information/card_information.dart';
import 'package:catalyst_voices/widgets/indicators/grab_handler_indicator.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class DraggableSheetCategoryInformation extends StatefulWidget {
  final CampaignCategoryDetailsViewModel category;
  final bool isActiveProposer;

  const DraggableSheetCategoryInformation({
    super.key,
    required this.category,
    required this.isActiveProposer,
  });

  @override
  State<DraggableSheetCategoryInformation> createState() =>
      _DraggableSheetCategoryInformationState();
}

class _DraggableSheetCategoryInformationState extends State<DraggableSheetCategoryInformation> {
  static const double _minChildSize = 0.1;

  late final DraggableScrollableController _dragController;

  double get _maxChildSize => widget.isActiveProposer ? 0.95 : 0.35;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _dragController,
      minChildSize: _minChildSize,
      initialChildSize: _minChildSize,
      maxChildSize: _maxChildSize,
      builder: (context, scrollController) => Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: context.colors.elevationsOnSurfaceNeutralLv1White,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragUpdate: _onVerticalDrag,
              child: const GrabHandlerIndicator(),
            ),
            Expanded(
              child: CardInformation(
                category: widget.category,
                isActiveProposer: widget.isActiveProposer,
                scrollController: scrollController,
                padding: EdgeInsets.zero,
                boxConstraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dragController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _dragController = DraggableScrollableController();
  }

  void _onVerticalDrag(DragUpdateDetails details) {
    final delta = details.delta.dy;
    final currentSize = _dragController.size;

    final screenHeight = MediaQuery.sizeOf(context).height;
    final sizeChange = -delta / screenHeight;
    final newSize = currentSize + sizeChange;

    final clampedSize = newSize.clamp(_minChildSize, _maxChildSize);
    _dragController.jumpTo(clampedSize);
  }
}
