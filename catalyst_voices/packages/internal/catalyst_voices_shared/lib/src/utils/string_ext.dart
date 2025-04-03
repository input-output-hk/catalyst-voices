import 'package:catalyst_voices_shared/src/utils/uuid_utils.dart';
import 'package:uuid_plus/uuid_plus.dart';

extension StringExt on String {
  String? get first => isEmpty ? null : substring(0, 1);

  bool get isBlank => trim().isEmpty;

  bool get isNotBlank => !isBlank;

  String withBullet() => withPrefix('• ');

  String capitalize() {
    if (isNotEmpty) {
      return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
    } else {
      return '';
    }
  }

  bool equalsIgnoreCase(String? other) {
    return toLowerCase() == other?.toLowerCase();
  }

  String starred({
    bool leading = true,
    bool isEnabled = true,
  }) {
    if (!isEnabled) {
      return this;
    }

    return leading ? withPrefix('*') : withSuffix('*');
  }

  String withPrefix(String value) => '$value$this';

  String withSuffix(String value) => '$this$value';
}

extension UrlParser on String {
  Uri getUri() {
    return Uri.parse(this);
  }
}

extension UuidStringUtils on String {
  DateTime get dateTime => UuidV7.parseDateTime(this, utc: true);

  DateTime? get tryDateTime {
    try {
      return dateTime;
    } catch (_) {
      return null;
    }
  }

  int get version => UuidUtils.version(this);
}
