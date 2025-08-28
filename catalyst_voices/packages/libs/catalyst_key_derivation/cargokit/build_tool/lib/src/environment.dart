/// This is copied from Cargokit (which is the official way to use it currently)
/// Details: https://fzyzcjy.github.io/flutter_rust_bridge/manual/integrate/builtin

import 'dart:io';

class Environment {
  /// Current build configuration (debug or release).
  static String get configuration =>
      _getEnv("CARGOKIT_CONFIGURATION").toLowerCase();

  /// List of architectures to build for (arm64, armv7, x86_64).
  static List<String> get darwinArchs =>
      _getEnv("CARGOKIT_DARWIN_ARCHS").split(' ');

  /// Platform name (macosx, iphoneos, iphonesimulator).
  static String get darwinPlatformName =>
      _getEnv("CARGOKIT_DARWIN_PLATFORM_NAME");

  static bool get isDebug => configuration == 'debug';

  static bool get isRelease => configuration == 'release';

  static String get javaHome => _getEnvPath("CARGOKIT_JAVA_HOME");

  /// Path to the crate manifest (containing Cargo.toml).
  static String get manifestDir => _getEnvPath('CARGOKIT_MANIFEST_DIR');

  // Pod

  // Gradle
  static String get minSdkVersion => _getEnv("CARGOKIT_MIN_SDK_VERSION");

  static String get ndkVersion => _getEnv("CARGOKIT_NDK_VERSION");

  /// Final output directory where the build artifacts are placed.
  static String get outputDir => _getEnvPath('CARGOKIT_OUTPUT_DIR');

  /// Directory inside root project. Not necessarily root folder. Symlinks are
  /// not resolved on purpose.
  static String get rootProjectDir => _getEnv('CARGOKIT_ROOT_PROJECT_DIR');
  static String get sdkPath => _getEnvPath("CARGOKIT_SDK_DIR");
  // CMAKE
  static String get targetPlatform => _getEnv("CARGOKIT_TARGET_PLATFORM");
  static List<String> get targetPlatforms =>
      _getEnv("CARGOKIT_TARGET_PLATFORMS").split(',');

  /// Temporary directory where Rust build artifacts are placed.
  static String get targetTempDir => _getEnv("CARGOKIT_TARGET_TEMP_DIR");

  static String _getEnv(String key) {
    final res = Platform.environment[key];
    if (res == null) {
      throw Exception("Missing environment variable $key");
    }
    return res;
  }

  static String _getEnvPath(String key) {
    final res = _getEnv(key);
    if (Directory(res).existsSync()) {
      return res.resolveSymlink();
    } else {
      return res;
    }
  }
}

extension on String {
  String resolveSymlink() => File(this).resolveSymbolicLinksSync();
}
