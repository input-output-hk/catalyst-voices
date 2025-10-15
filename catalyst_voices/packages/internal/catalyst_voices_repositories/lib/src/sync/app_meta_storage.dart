import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/app_meta_dto.dart';
import 'package:catalyst_voices_repositories/src/storage/local_storage.dart';

const _dataKey = 'Data';
const _key = 'AppMeta';

abstract interface class AppMetaStorage {
  Future<AppMeta> read();

  Future<void> write(AppMeta data);
}

final class AppMetaStorageLocalStorage extends LocalStorage implements AppMetaStorage {
  AppMetaStorageLocalStorage({
    required super.sharedPreferences,
  }) : super(
         key: _key,
         allowList: {
           _dataKey,
         },
       );

  @override
  Future<AppMeta> read() async {
    final encoded = await readString(key: _dataKey);
    final decoded = encoded != null ? jsonDecode(encoded) as Map<String, dynamic> : null;
    final dto = decoded != null ? AppMetaDto.fromJson(decoded) : AppMetaDto();
    return dto.toModel();
  }

  @override
  Future<void> write(AppMeta data) async {
    final dto = AppMetaDto.fromModel(data);
    final encoded = jsonEncode(dto.toJson());
    await writeString(encoded, key: _dataKey);
  }
}
