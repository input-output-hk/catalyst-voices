import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/model/document_composite_entity.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_artifacts.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_authors.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_collaborators.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_parameters.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:drift/drift.dart';

final class DocumentCompositeFactory {
  DocumentCompositeFactory._();

  static DocumentCompositeEntity create({
    String? id,
    String? ver,
    Map<String, dynamic> contentData = const {},
    DocumentContentType contentType = DocumentContentType.json,
    DocumentType type = DocumentType.proposalDocument,
    DateTime? createdAt,
    List<CatalystId>? authors,
    String? refId,
    String? refVer,
    String? replyId,
    String? replyVer,
    String? section,
    String? templateId,
    String? templateVer,
    List<DocumentRef> parameters = const [],
    List<CatalystId> collaborators = const [],
    DocumentArtifact? artifact,
  }) {
    id ??= DocumentRefFactory.randomUuidV7();
    ver ??= id;
    authors ??= const [];
    artifact ??= DocumentArtifact(Uint8List(0));

    final docEntity = DocumentEntityV2(
      id: id,
      ver: ver,
      contentType: contentType.value,
      content: DocumentDataContent(contentData),
      createdAt: createdAt ?? ver.tryDateTime ?? DateTime.now(),
      type: type,
      authors: authors,
      refId: refId,
      refVer: refVer,
      replyId: replyId,
      replyVer: replyVer,
      section: section,
      templateId: templateId,
      templateVer: templateVer,
      collaborators: collaborators,
      parameters: DocumentParameters(parameters.map((e) => e.toSignedDocumentRef()).toSet()),
    );

    final docArtifact = DocumentArtifactEntity(
      data: artifact.value,
      id: id,
      ver: ver,
    );

    final authorsEntities = authors
        .map(
          (e) => DocumentAuthorEntity(
            documentId: docEntity.id,
            documentVer: docEntity.ver,
            accountId: e.toUri().toString(),
            accountSignificantId: e.toSignificant().toUri().toString(),
            username: e.username,
          ),
        )
        .toList();

    final collaboratorsEntities = collaborators
        .map(
          (e) => DocumentCollaboratorEntity(
            documentId: docEntity.id,
            documentVer: docEntity.ver,
            accountId: e.toUri().toString(),
            accountSignificantId: e.toSignificant().toUri().toString(),
            username: e.username,
          ),
        )
        .toList();

    final parametersEntities = parameters
        .map(
          (e) => DocumentParameterEntity(
            id: e.id,
            ver: e.ver!,
            documentId: docEntity.id,
            documentVer: docEntity.ver,
          ),
        )
        .toList();

    return DocumentCompositeEntity(
      docEntity,
      artifact: docArtifact,
      authors: authorsEntities,
      parameters: parametersEntities,
      collaborators: collaboratorsEntities,
    );
  }
}
