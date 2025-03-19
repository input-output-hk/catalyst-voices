import 'package:catalyst_voices/pages/registration/pictures/task_picture.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

const _wordsPerColumnCount = 6;
const _firstHighlightIndex = [0];
const _allHighlightIndex = [0, 1, 2, 3, 4, 5];

class SeedPhrasePicture extends StatelessWidget {
  final bool indicateSelection;
  final TaskPictureType type;

  const SeedPhrasePicture({
    super.key,
    this.indicateSelection = false,
    this.type = TaskPictureType.normal,
  });

  @override
  Widget build(BuildContext context) {
    return TaskPicture(
      child: TaskPictureIconBox(
        type: type,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.all(constraints.maxWidth * 0.176),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _Words(
                    indicateSelection: indicateSelection,
                    type: type,
                  ),
                  if (type == TaskPictureType.success)
                    VoicesAssets.icons.check.buildIcon(size: 48),
                  if (type == TaskPictureType.error)
                    VoicesAssets.icons.x.buildIcon(size: 48),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Words extends StatelessWidget {
  const _Words({
    required this.indicateSelection,
    required this.type,
  });

  final bool indicateSelection;
  final TaskPictureType type;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _WordsColumn(
            key: const ValueKey('LeftColumnKey'),
            highlightIndexes: switch (type) {
              TaskPictureType.normal when indicateSelection =>
                _firstHighlightIndex,
              TaskPictureType.normal => const [],
              TaskPictureType.success ||
              TaskPictureType.error =>
                _allHighlightIndex,
            },
            count: _wordsPerColumnCount,
            type: type,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _WordsColumn(
            key: const ValueKey('RightColumnKey'),
            highlightIndexes: switch (type) {
              TaskPictureType.normal => const [],
              TaskPictureType.success ||
              TaskPictureType.error =>
                _allHighlightIndex,
            },
            count: _wordsPerColumnCount,
            type: type,
          ),
        ),
      ],
    );
  }
}

class _WordsColumn extends StatelessWidget {
  final List<int> highlightIndexes;
  final int count;
  final TaskPictureType type;

  const _WordsColumn({
    super.key,
    this.highlightIndexes = const [],
    this.count = 6,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        count,
        (index) {
          return _Word(
            isSelected: highlightIndexes.contains(index),
            type: type,
          );
        },
      ),
    );
  }
}

class _Word extends StatelessWidget {
  final bool isSelected;
  final TaskPictureType type;

  const _Word({
    this.isSelected = false,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = type.foregroundColor(theme, isHighlight: isSelected);

    return AnimatedContainer(
      height: 6.72,
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(1.12),
      ),
    );
  }
}
