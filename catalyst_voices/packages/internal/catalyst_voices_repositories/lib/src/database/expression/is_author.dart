import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:drift/drift.dart';

final class IsAuthor extends CustomExpression<bool> {
  IsAuthor({
    required CatalystId id,
  }) : super(
          //ignore: lines_longer_than_80_chars
          "json_extract(metadata, '\$.authors') LIKE '%${id.toSignificant().toUri().toStringWithoutScheme()}%'",
        );
}

extension MetadataColumnExt
    on GeneratedColumnWithTypeConverter<DocumentDataMetadata, Uint8List> {
  Expression<bool> author(CatalystId id) => IsAuthor(id: id);
}
