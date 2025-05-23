import 'dart:async';
import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/sync_stats_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

const _dataKey = 'Data';
const _key = 'SyncStats';

final class SyncStatsLocalStorage extends LocalStorage implements SyncStatsStorage {
  final _streamController = StreamController<SyncStats?>.broadcast();

  SyncStatsLocalStorage({
    required super.sharedPreferences,
  }) : super(
          key: _key,
          allowList: {
            _dataKey,
          },
        );

  @override
  Future<void> dispose() async {
    await _streamController.close();
  }

  @override
  Future<SyncStats?> read() async {
    final encoded = await readString(key: _dataKey);
    final decoded = encoded != null ? jsonDecode(encoded) as Map<String, dynamic> : null;
    final dto = decoded != null ? SyncStatsDto.fromJson(decoded) : null;
    return dto?.toModel();
  }

  @override
  Stream<SyncStats?> watch() async* {
    yield await read();
    yield* _streamController.stream;
  }

  @override
  Future<void> write(SyncStats? data) async {
    final dto = data != null ? SyncStatsDto.fromModel(data) : null;
    final encoded = dto != null ? jsonEncode(dto.toJson()) : null;
    await writeString(encoded, key: _dataKey);

    _streamController.add(data);
  }
}

// TODO(damian-molinski): try extracting common pattern with watch / dispose (Listenable/Watchable).
abstract interface class SyncStatsStorage {
  Future<void> dispose();

  Future<SyncStats?> read();

  Stream<SyncStats?> watch();

  Future<void> write(SyncStats? data);
}
