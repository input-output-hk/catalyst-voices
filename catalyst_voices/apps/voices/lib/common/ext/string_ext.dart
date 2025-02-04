extension StringExt on String {
  String? get firstLetter => isEmpty ? null : substring(0, 1);

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
