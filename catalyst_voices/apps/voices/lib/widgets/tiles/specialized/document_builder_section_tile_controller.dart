import 'package:catalyst_voices/widgets/tiles/specialized/document_builder_section_tile.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

/// A controller that holds cached data for [DocumentBuilderSectionTile] to allow these tiles
/// be disposed and reinitialized later without losing the cached data.
final class DocumentBuilderSectionTileController {
  final Map<DocumentNodeId, Object> _data = {};

  DocumentBuilderSectionTileController();

  void dispose() {
    _data.clear();
  }

  T? getData<T extends Object?>(DocumentNodeId nodeId) {
    return _data[nodeId] as T?;
  }

  void setData(DocumentNodeId nodeId, Object data) {
    _data[nodeId] = data;
  }
}

/// An [InheritedWidget] which should be injected above the [DocumentBuilderSectionTile]
/// in the widget tree that provides a [DocumentBuilderSectionTileController].
final class DocumentBuilderSectionTileControllerScope extends InheritedWidget {
  final DocumentBuilderSectionTileController controller;

  const DocumentBuilderSectionTileControllerScope({
    super.key,
    required this.controller,
    required super.child,
  });

  @override
  bool updateShouldNotify(DocumentBuilderSectionTileControllerScope oldWidget) {
    return controller != oldWidget.controller;
  }

  static DocumentBuilderSectionTileController of(BuildContext context) {
    final controller = context
        .dependOnInheritedWidgetOfExactType<DocumentBuilderSectionTileControllerScope>()
        ?.controller;

    assert(
      controller != null,
      'Unable to find DocumentBuilderSectionTileControllerScope in widget tree',
    );

    return controller!;
  }
}
