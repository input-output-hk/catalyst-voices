import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class ColumnsRow extends StatelessWidget {
  final int columnsCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final List<Widget> children;

  const ColumnsRow({
    super.key,
    required this.columnsCount,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final columnCount = (children.length / columnsCount).ceil();
    final columns = children.slices(columnCount).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columns
          .map((e) => _Column(spacing: crossAxisSpacing, children: e))
          .map((e) => Expanded(child: e))
          .expandIndexed(
            (index, element) => [
              if (index != 0) SizedBox(width: mainAxisSpacing),
              element,
            ],
          )
          .toList(),
    );
  }
}

class _Column extends StatelessWidget {
  final double spacing;
  final List<Widget> children;

  const _Column({
    this.spacing = 0.0,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children
          .expandIndexed(
            (index, element) => [
              if (index != 0) SizedBox(height: spacing),
              element,
            ],
          )
          .toList(),
    );
  }
}
