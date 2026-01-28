import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// A class that describes updates to the [DocumentDataMetadata].
final class DocumentDataMetadataUpdate extends Equatable {
  final Optional<DocumentRef>? id;
  final Optional<List<CatalystId>>? collaborators;

  const DocumentDataMetadataUpdate({
    this.id,
    this.collaborators,
  });

  @override
  List<Object?> get props => [id, collaborators];
}
