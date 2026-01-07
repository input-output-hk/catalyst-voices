import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Metadata object for document. Have to have id and version eg. exact [DocumentRef].
///
/// Do not confuse this with metadata of single document.
/// We have concept of *useful* document such as [ProposalDocument] or [CommentDocument]
/// which is combination of multiple documents(eg. template + data).
abstract base class DocumentMetadata extends Equatable {
  final DocumentRef selfRef;

  /// A list of referenced parameters like brand, campaign or category.
  final DocumentParameters parameters;

  DocumentMetadata({
    required this.selfRef,
    required this.parameters,
  }) : assert(selfRef.isExact, 'SelfRef have to be exact!');

  @override
  @mustCallSuper
  List<Object?> get props => [
    selfRef,
    parameters,
  ];
}
