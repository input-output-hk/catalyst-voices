import 'dart:math';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid_plus/uuid_plus.dart';

abstract final class DocumentRefFactory {
  static final Random _random = Random(57342052346526);
  static var _timestamp = DateTime.now().millisecondsSinceEpoch;

  static DraftRef draftRef() {
    return DraftRef.first(randomUuidV7());
  }

  static String randomUuidV7() {
    return const UuidV7().generate(
      options: V7Options(
        _randomDateTime().millisecondsSinceEpoch,
        _randomBytes(10),
      ),
    );
  }

  static SignedDocumentRef signedDocumentRef() {
    return SignedDocumentRef.first(randomUuidV7());
  }

  static String uuidV7At(DateTime dateTime) {
    final ts = dateTime.millisecondsSinceEpoch;
    final rand = Uint8List.fromList([42, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
    return const UuidV7().generate(options: V7Options(ts, rand));
  }

  static List<int> _randomBytes(int length) {
    return List.generate(length, (index) => _random.nextInt(256));
  }

  static DateTime _randomDateTime() {
    final timestamp = _timestamp;
    _timestamp++;

    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }
}
