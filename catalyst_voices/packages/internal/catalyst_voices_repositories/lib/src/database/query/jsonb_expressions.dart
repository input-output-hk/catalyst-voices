import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:drift/drift.dart';
import 'package:drift/extensions/json1.dart';

final class ContainsAuthorId extends CustomExpression<bool> {
  ContainsAuthorId({
    required CatalystId id,
  }) : super(
          //ignore: lines_longer_than_80_chars
          "json_extract(metadata, '\$.authors') LIKE '%${id.toSignificant().toUri().toStringWithoutScheme()}%'",
        );
}

final class ContainsTitle extends CustomExpression<bool> {
  ContainsTitle({
    required String query,
  }) : super(
          //ignore: lines_longer_than_80_chars
          "json_extract(content, '\$.setup.title.title') LIKE '%$query%'",
        );
}

extension ContentColumnExt
    on GeneratedColumnWithTypeConverter<DocumentDataContent, Uint8List> {
  Expression<bool> hasTitle(String query) => ContainsTitle(query: query);
}

extension MetadataColumnExt
    on GeneratedColumnWithTypeConverter<DocumentDataMetadata, Uint8List> {
  Expression<bool> isAuthor(CatalystId id) => ContainsAuthorId(id: id);

  Expression<bool> isCategory(SignedDocumentRef ref) {
    return jsonExtract<String>(r'$.categoryId.id').equals(ref.id);
  }
}
