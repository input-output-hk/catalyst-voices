extension StringExt on String {
  String capitalize() {
    if (isNotEmpty) {
      return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
    } else {
      return '';
    }
  }
}

extension UrlParser on String {
  Uri getUri() {
    return Uri.parse(this);
  }
}
