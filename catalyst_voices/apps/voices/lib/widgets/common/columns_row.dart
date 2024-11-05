import 'package:catalyst_voices/widgets/seed_phrase/seed_phrases_completer.dart';
import 'package:catalyst_voices/widgets/seed_phrase/seed_phrases_picker.dart';
import 'package:catalyst_voices/widgets/seed_phrase/seed_phrases_viewer.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// A widget that arranges children into columns within a row.
///
/// This widget divides its children into columns based on the [columnsCount]
/// property. Each column is then laid out vertically with optional spacing
/// between children.
///
/// The [mainAxisSpacing] property controls the horizontal spacing between
/// columns, while the [crossAxisSpacing] property controls the vertical
/// spacing within each column.
///
/// See following widgets for examples of usage.
///   - [SeedPhrasesViewer], [SeedPhrasesPicker] and [SeedPhrasesCompleter]
class ColumnsRow extends StatelessWidget {
  /// The number of columns to create.
  final int columnsCount;

  /// The horizontal spacing between columns. Defaults to 0.0.
  final double mainAxisSpacing;

  /// The vertical spacing between children within each column. Defaults to 0.0.
  final double crossAxisSpacing;

  /// The children to be arranged in columns.
  final List<Widget> children;

  /// Creates a [ColumnsRow] widget.
  ///
  /// The [columnsCount] argument must be positive.
  const ColumnsRow({
    super.key,
    required this.columnsCount,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    required this.children,
  }) : assert(columnsCount >= 0, 'Columns count can not be zero or negative');

  @override
  Widget build(BuildContext context) {
    final columnCount = (children.length / columnsCount).ceil();
    final columns = children.slices(columnCount).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columns
          .map((e) => _Column(spacing: crossAxisSpacing, children: e))
          .map<Widget>((e) => Expanded(child: e))
          .separatedBy(SizedBox(width: mainAxisSpacing))
          .toList(),
    );
  }
}

/// A helper widget that arranges children vertically with optional spacing.
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
      children: children.separatedBy(SizedBox(height: spacing)).toList(),
    );
  }
}
