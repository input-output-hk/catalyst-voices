import 'package:catalyst_voices_repositories/src/api/models/component_status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'component.g.dart';

@JsonSerializable(createToJson: false)
final class Component {
  final String id;
  final String name;
  final String description;
  final ComponentStatus status;
  final String? group;
  final bool? isParent;

  const Component({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    this.group,
    this.isParent,
  });

  factory Component.fromJson(Map<String, dynamic> json) => _$ComponentFromJson(json);
}
