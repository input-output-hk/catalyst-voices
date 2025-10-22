import 'package:catalyst_voices_repositories/src/api/models/component.dart';
import 'package:catalyst_voices_repositories/src/common/json.dart';
import 'package:json_annotation/json_annotation.dart';

part 'components.g.dart';

@JsonSerializable(createToJson: false)
final class Components {
  final List<Component> components;

  const Components(this.components);

  factory Components.fromJson(Json json) => _$ComponentsFromJson(json);
}
