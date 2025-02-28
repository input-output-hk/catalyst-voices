import 'package:catalyst_voices_shared/src/utils/uuid_utils.dart';

extension StringExt on String {
  String? get firstLetter => isEmpty ? null : substring(0, 1);

  bool get isBlank => trim().isEmpty;

  bool get isNotBlank => !isBlank;

  String capitalize() {
    if (isNotEmpty) {
      return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
    } else {
      return '';
    }
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
  DateTime get dateTime => UuidUtils.dateTime(this);

  int get version => UuidUtils.version(this);
}
