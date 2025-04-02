import 'package:catalyst_voices/widgets/common/simple_tree_view.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

class Overview {
  Overview(this.$);
  late PatrolTester $;

  late final metadata = Metadata($);
  final overviewBranch = const ValueKey('Segment[0]NodeMenu');

  Future<void> tap() async {
    await $(overviewBranch).$(SimpleTreeViewRootRow).tap();
  }

  bool isColapsed()  {
    try {
      return $(checkSvgBytesLoaderPath('assets/icons/node-open.svg')).exists;
    } catch (_) {
      return false;
    }
  }
  
  Finder checkSvgBytesLoaderPath(String path) {
    return find.byWidgetPredicate(
        (widget) =>
            widget is CatalystSvgPicture &&
            (widget.bytesLoader as dynamic).assetName ==path,
      );
  }

}

class Metadata extends Overview{
  Metadata(super.$);
  final metadataKey = const ValueKey('NodeMenuoverview.metadataRowKey');
  
  @override
  Future<void> tap() async {
    await $(metadataKey).$(SimpleTreeViewRootRow).tap();
  }
}
