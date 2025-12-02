import 'package:catalyst_voices_models/catalyst_voices_models.dart';

/// An algorithm that traverses document properties in opinionated way.
final class DocumentNodeTraverser {
  /// Expands nested properties.
  static Iterable<DocumentProperty> findSectionsAndSubsections(
    DocumentProperty property,
  ) sync* {
    if (property.schema.isSectionOrSubsection) {
      yield property;
    }

    switch (property) {
      case DocumentListProperty():
        for (final childProperty in property.properties) {
          yield* findSectionsAndSubsections(childProperty);
        }
      case DocumentObjectProperty():
        for (final childProperty in property.properties) {
          yield* findSectionsAndSubsections(childProperty);
        }
      case DocumentValueProperty():
      // value property doesn't have children
    }
  }

  /// Retrieves the value of a property located at the specified [nodeId].
  ///
  /// This method traverses the nested structure of the [data] using
  /// the paths defined in the [nodeId]. If the specified path exists, the
  /// corresponding property value is returned. If the path is invalid or does
  /// not exist, the method returns `null`.
  static T? getValue<T extends Object>(DocumentNodeId nodeId, Map<String, dynamic> data) {
    Object? object = data;
    for (final path in nodeId.paths) {
      if (object is Map<String, dynamic>) {
        object = object[path];
      } else if (object is List) {
        final index = int.tryParse(path);
        if (index == null) {
          // index must be a number
          return null;
        }
        object = object[index];
      } else {
        return null;
      }
    }

    return object is T ? object : null;
  }
}
