import 'package:catalyst_voices_repositories/generated/api/cat_gateway.models.swagger.dart'
    show IdSelector;
import 'package:json_annotation/json_annotation.dart';

part 'document_index_query_filters_dto.g.dart';

// Note. OpenAPI spec is incorrect at the moment. This dto is here as
// temporary workaround.
@JsonSerializable(createFactory: false, includeIfNull: false)
final class IdSelectorDto extends IdSelector {
  final String? eq;
  final String? min;
  final String? max;
  @JsonKey(name: 'in')
  final List<String>? inside;

  const IdSelectorDto.eq(this.eq) : min = null, max = null, inside = null;

  const IdSelectorDto.range({
    required this.min,
    required this.max,
  }) : eq = null,
       inside = null;

  const IdSelectorDto.inside(List<String> data) : eq = null, min = null, max = null, inside = data;

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  // ignore: hash_and_equals, avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => super.hashCode;

  @override
  Map<String, dynamic> toJson() => _$IdSelectorDtoToJson(this);
}
