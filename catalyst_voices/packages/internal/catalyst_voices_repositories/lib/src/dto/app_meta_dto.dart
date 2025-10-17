import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_ref_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_meta_dto.g.dart';

@JsonSerializable()
final class AppMetaDto {
  final DocumentRefDto? activeCampaign;

  AppMetaDto({
    this.activeCampaign,
  });

  factory AppMetaDto.fromJson(Map<String, dynamic> json) {
    return _$AppMetaDtoFromJson(json);
  }

  AppMetaDto.fromModel(AppMeta data)
    : this(
        activeCampaign: data.activeCampaign != null
            ? DocumentRefDto.fromModel(data.activeCampaign!)
            : null,
      );

  Map<String, dynamic> toJson() => _$AppMetaDtoToJson(this);

  AppMeta toModel() {
    return AppMeta(
      activeCampaign: activeCampaign?.toModel(),
    );
  }
}
