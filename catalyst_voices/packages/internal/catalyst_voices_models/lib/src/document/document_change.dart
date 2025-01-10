import 'package:catalyst_voices_models/src/document/document.dart';
import 'package:catalyst_voices_models/src/document/document_node_id.dart';
import 'package:equatable/equatable.dart';

/// Describes an intent to change a document.
///
/// This allows to enqueue changes coming
/// from multiple sources and apply them together.
sealed class DocumentChange extends Equatable {
  const DocumentChange();
}

/// Describes an intent to change a property value in the document.
final class DocumentValueChange extends DocumentChange {
  /// The id of the document node to be updated.
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

/// Describes an intent to add a new (empty) item in a [DocumentPropertyList].
final class DocumentAddListItemChange extends DocumentChange {
  /// The [DocumentNodeId] of the [DocumentPropertyList]
  /// where the new item will be added.
  final DocumentNodeId nodeId;

  /// The default constructor for the [DocumentAddListItemChange].
  const DocumentAddListItemChange({
    required this.nodeId,
  });

  @override
  List<Object?> get props => [nodeId];
}

/// Describes an intent to remove an item from the [DocumentPropertyList].
final class DocumentRemoveListItemChange extends DocumentChange {
  /// The [DocumentNodeId] of the child in [DocumentPropertyList]
  /// which is going to be removed.
  final DocumentNodeId nodeId;

  /// The default constructor for the [DocumentRemoveListItemChange].
  const DocumentRemoveListItemChange({
    required this.nodeId,
  });

  @override
  List<Object?> get props => [nodeId];
}
