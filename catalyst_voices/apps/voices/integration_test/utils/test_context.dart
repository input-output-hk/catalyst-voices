class TestContext {
  TestContext._privateConstructor();
  static final TestContext instance = TestContext._privateConstructor();
  Map<String, String> context = {};

  static bool has({required String key}) {
    return TestContext.instance.context.containsKey(key);
  }

  static void save({required String key, required String value}) {
    if (has(key: key)) {
      throw Exception('You tried to override "$key" property. Its not allowed');
    }
    TestContext.instance.context[key] = value;
  }

  static void delete({required String key}) {
    if (has(key: key)) {
      TestContext.instance.context.remove(key);
    }
  }

  static void saveWithOverride({required String key, required String value}) {
    if (has(key: key)) {
      delete(key: key);
    }
    TestContext.instance.context[key] = value;
  }

  static String get({required String key}) {
    if (has(key: key)) {
      return TestContext.instance.context[key]!;
    }
    throw Exception('You tried to access $key property, but it does not exist.');
  }

  static void clearContext() {
    TestContext.instance.context.clear();
  }
}
