import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_dto.dart';

class DocumentMapperImpl implements DocumentMapper {
  const DocumentMapperImpl();

  @override
  Map<String, dynamic> metadataToMap(DocumentDataMetadata metadata) {
    final dto = DocumentDataMetadataDto.fromModel(metadata);
    final json = dto.toJson();
    return json;
  }

  @override
  DocumentDataContent toContent(Document document) {
    final dto = DocumentDto.fromModel(document);
    final dataDto = dto.toJson();
    return dataDto.toModel();
  }
}
