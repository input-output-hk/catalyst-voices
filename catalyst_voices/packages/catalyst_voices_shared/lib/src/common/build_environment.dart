enum BuildEnvironment {
  dev,
  qa,
  preprod,
  prod;

  /// Converts a `String` value to corrsponding name value
  /// of the `BuildEnvironment` enum.
  static String fromEnvironment(String value) {
    switch (value) {
      case 'dev':
        return BuildEnvironment.dev.name;
      case 'qa':
        return BuildEnvironment.qa.name;
      case 'preprod':
        return BuildEnvironment.preprod.name;
      case 'prod':
        return BuildEnvironment.prod.name;
      default:
        return BuildEnvironment.dev.name;
    }
  }
}
