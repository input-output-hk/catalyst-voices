import 'package:catalyst_voices_repositories/src/database/table/document_authors.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_collaborators.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_parameters.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';

final class DocumentCompositeEntity {
  final DocumentEntityV2 doc;
  final List<DocumentAuthorEntity> authors;
  final List<DocumentCollaboratorEntity> collaborators;
  final List<DocumentParameterEntity> parameters;

  // TODO(damian-molinski): change to named and optional.
  const DocumentCompositeEntity(
    this.doc,
    this.authors,
    this.collaborators,
    this.parameters,
  );
}
