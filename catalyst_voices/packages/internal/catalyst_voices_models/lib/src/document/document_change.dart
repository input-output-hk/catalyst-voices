import 'package:catalyst_voices_models/src/document/document.dart';
import 'package:catalyst_voices_models/src/document/document_node_id.dart';
import 'package:equatable/equatable.dart';

/// Describes an intent to change a property in the document.
///
/// This allows to enqueue changes coming
/// from multiple sources and apply them together.
final class DocumentChange extends Equatable {
  /// The id of the document node to be updated.
  final DocumentNodeId nodeId;

  /// The new value to be assigned to the [nodeId] in the [Document].
  final Object? value;

  /// The default constructor for the [DocumentChange].
  const DocumentChange({
    required this.nodeId,
    required this.value,
  });

  @override
  List<Object?> get props => [nodeId, value];
}
