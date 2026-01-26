import 'package:catalyst_voices_repositories/src/database/table/document_artifacts.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_authors.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_collaborators.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_parameters.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';

final class DocumentCompositeEntity {
  final DocumentEntityV2 doc;
  final DocumentArtifactEntity artifact;
  final List<DocumentAuthorEntity> authors;
  final List<DocumentCollaboratorEntity> collaborators;
  final List<DocumentParameterEntity> parameters;

  const DocumentCompositeEntity(
    this.doc, {
    required this.artifact,
    this.authors = const [],
    this.collaborators = const [],
    this.parameters = const [],
  });
}
