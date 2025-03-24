import 'package:catalyst_voices_repositories/generated/api/cat_gateway.models.swagger.dart'
    show EqOrRangedId;
import 'package:json_annotation/json_annotation.dart';

part 'document_index_query_filters_dto.g.dart';

// Note. OpenAPI spec is incorrect at the moment. This dto is here as
// temporary workaround.
@JsonSerializable(createFactory: false, includeIfNull: false)
final class EqOrRangedIdDto extends EqOrRangedId {
  final String? eq;
  final String? min;
  final String? max;

  const EqOrRangedIdDto.eq(this.eq)
      : min = null,
        max = null;

  const EqOrRangedIdDto.range({
    required this.min,
    required this.max,
  }) : eq = null;

  @override
  Map<String, dynamic> toJson() => _$EqOrRangedIdDtoToJson(this);
}
