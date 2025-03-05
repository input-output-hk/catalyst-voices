import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_dto.dart';

class DocumentMapperImpl implements DocumentMapper {
  const DocumentMapperImpl();

  @override
  DocumentDataContent toContent(Document document) {
    final dto = DocumentDto.fromModel(document);
    final dataDto = dto.toJson();
    return dataDto.toModel();
  }
}
