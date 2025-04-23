import 'package:catalyst_voices_shared/src/utils/uuid_utils.dart';
import 'package:uuid_plus/uuid_plus.dart';

extension StringExt on String {
  String? get first => isEmpty ? null : substring(0, 1);

  bool get isBlank => trim().isEmpty;

  bool get isNotBlank => !isBlank;

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

  // TODO(dtscalac): temporary solution to format dynamic strings as plural,
  // after F14 the document schema must be altered to support
  // other languages than English.
  //
  // The current workaround won't work for exceptions like "mouse" -> "mice",
  // this was accepted for the time being.
  String formatAsPlural(int count) {
    if (isEmpty) {
      // cannot make plural, lets just use the number
      return count.toString();
    }

    if (endsWith('s')) {
      // Do not append "s" at the end because the word already ends with it.
      return '$count $this';
    }

    return switch (count) {
      1 => '$count $this',
      _ => '$count ${this}s',
    };
  }

  String? nullIfEmpty() {
    if (isEmpty) {
      return null;
    }
    return this;
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

  String withBullet() => withPrefix('• ');

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
