import 'package:catalyst_voices_models/src/document/document.dart';
import 'package:catalyst_voices_models/src/document/document_node_id.dart';
import 'package:equatable/equatable.dart';

/// Describes an intent to change a document.
///
/// This allows to enqueue changes coming
/// from multiple sources and apply them together.
sealed class DocumentChange extends Equatable {
  const DocumentChange();

  /// The [DocumentNodeId] of the node that will be changed.
  DocumentNodeId get nodeId;

  /// Returns `true` is this [DocumentChange] is intended for the [node],
  /// `false` otherwise.
  bool targetsDocumentNode(DocumentNode node) {
    final targetedNodeId = nodeId;
    return targetedNodeId == node.nodeId ||
        targetedNodeId.isChildOf(node.nodeId);
  }
}

/// Describes an intent to change a property value in the document.
final class DocumentValueChange extends DocumentChange {
  /// The id of the document node to be updated.
  @override
  final DocumentNodeId nodeId;

  /// The new value to be assigned to the [nodeId] in the [Document].
  final Object? value;

  /// The default constructor for the [DocumentValueChange].
  const DocumentValueChange({
    required this.nodeId,
    required this.value,
  });

  @override
  List<Object?> get props => [nodeId, value];
}

/// Describes an intent to add a new (empty) item in a [DocumentListProperty].
final class DocumentAddListItemChange extends DocumentChange {
  /// The [DocumentNodeId] of the [DocumentListProperty]
  /// where the new item will be added.
  @override
  final DocumentNodeId nodeId;

  /// The default constructor for the [DocumentAddListItemChange].
  const DocumentAddListItemChange({
    required this.nodeId,
  });

  @override
  List<Object?> get props => [nodeId];
}

/// Describes an intent to remove an item from the [DocumentListProperty].
final class DocumentRemoveListItemChange extends DocumentChange {
  /// The [DocumentNodeId] of the child in [DocumentListProperty]
  /// which is going to be removed.
  @override
  final DocumentNodeId nodeId;

  /// The default constructor for the [DocumentRemoveListItemChange].
  const DocumentRemoveListItemChange({
    required this.nodeId,
  });

  @override
  List<Object?> get props => [nodeId];
}
