//wrapper that we should adapt to read actual i18n translations we use in the app
//it will also support different locales once we have it
//right now this class is here so we can easily replace this implementation and know where
class T {
  static String get(String key, {String? locale}) {
    return key;
  }
}
