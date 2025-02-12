part of 'voices_rich_text.dart';

/// Heuristic rule to exit current block when user inserts two consecutive
/// newlines.
///
/// This rule is similar to Quill's AutoExitBlockRule but
/// it always exits the block no matter if it was the last line
/// of the block or middle one.
@immutable
class _AutoExitBlockRule extends quill_int.InsertRule {
  const _AutoExitBlockRule();

  @override
  Delta? applyRule(
    quill.Document document,
    int index, {
    int? len,
    Object? data,
    quill.Attribute<dynamic>? attribute,
  }) {
    if (data is! String || data != '\n') {
      return null;
    }

    final itr = DeltaIterator(document.toDelta());
    final prev = itr.skip(index);
    final cur = itr.next();
    final blockStyle =
        quill.Style.fromJson(cur.attributes).getBlockExceptHeader();
    // We are not in a block, ignore.
    if (cur.isPlain || blockStyle == null) {
      return null;
    }
    // We are not on an empty line, ignore.
    if (!_isEmptyLine(prev, cur)) {
      return null;
    }

    // Here we now know that the line after `cur` is not in the same block
    // therefore we can exit this block.
    final attributes = cur.attributes ?? <String, dynamic>{};
    final k = attributes.keys
        .firstWhere(quill.Attribute.blockKeysExceptHeader.contains);
    attributes[k] = null;
    // retain(1) should be '\n', set it with no attribute
    return Delta()
      ..retain(index + (len ?? 0))
      ..retain(1, attributes);
  }

  bool _isEmptyLine(Operation? before, Operation? after) {
    if (before == null) {
      return true;
    }
    return before.data is String &&
        (before.data! as String).endsWith('\n') &&
        after!.data is String &&
        (after.data! as String).startsWith('\n');
  }
}
