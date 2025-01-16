import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'grouped_tags_dto.g.dart';

@JsonSerializable()
final class GroupedTagsSelectionDto {
  final String? group;
  final String? tag;

  const GroupedTagsSelectionDto({
    this.group,
    this.tag,
  });

  factory GroupedTagsSelectionDto.fromModel(GroupedTagsSelection tags) {
    return GroupedTagsSelectionDto(
      group: tags.group,
      tag: tags.tag,
    );
  }

  factory GroupedTagsSelectionDto.fromJson(Map<String, dynamic> json) =>
      _$GroupedTagsSelectionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GroupedTagsSelectionDtoToJson(this);

  GroupedTagsSelection toModel() {
    return GroupedTagsSelection(
      group: group,
      tag: tag,
    );
  }
}

class GroupedTagsSelectionConverter
    implements JsonConverter<GroupedTagsSelection?, Map<String, dynamic>?> {
  const GroupedTagsSelectionConverter();

  @override
  GroupedTagsSelection? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    return GroupedTagsSelectionDto.fromJson(json).toModel();
  }

  @override
  Map<String, dynamic>? toJson(GroupedTagsSelection? object) {
    if (object == null) {
      return null;
    }

    return GroupedTagsSelectionDto.fromModel(object).toJson();
  }
}
