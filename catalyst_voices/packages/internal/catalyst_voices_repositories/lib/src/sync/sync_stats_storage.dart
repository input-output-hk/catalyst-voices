import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/sync_stats_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

const _dataKey = 'Data';
const _key = 'SyncStats';

final class SyncStatsLocalStorage extends LocalStorage implements SyncStatsStorage {
  SyncStatsLocalStorage({
    required super.sharedPreferences,
  }) : super(
          key: _key,
          allowList: {
            _dataKey,
          },
        );

  @override
  Future<SyncStats> read() async {
    final encoded = await readString(key: _dataKey);
    final decoded = encoded != null ? jsonDecode(encoded) as Map<String, dynamic> : null;
    final dto = decoded != null ? SyncStatsDto.fromJson(decoded) : const SyncStatsDto();
    return dto.toModel();
  }

  @override
  Future<void> write(SyncStats? data) async {
    if (data == null) {
      await delete(key: _dataKey);
      return;
    }

    final dto = SyncStatsDto.fromModel(data);
    final encoded = jsonEncode(dto.toJson());
    await writeString(encoded, key: _dataKey);
  }
}

abstract interface class SyncStatsStorage {
  Future<SyncStats> read();

  Future<void> write(SyncStats? data);
}
