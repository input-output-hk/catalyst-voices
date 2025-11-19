/// Manifest file that documents asset versioning information.
class AssetVersionManifest {
  /// Timestamp when the manifest was generated.
  final String generated;

  /// Maps original filename to versioned filename.
  /// Example: {'flutter_bootstrap.js': 'flutter_bootstrap.abc12345.js'}
  final Map<String, String> versionedAssets;

  /// Maps original filename to its MD5 hash.
  /// Example: {'flutter_bootstrap.js': 'abc12345'}
  final Map<String, String> assetHashes;

  /// List of files that require manual versioning.
  final List<String> manuallyVersionedFiles;

  const AssetVersionManifest({
    required this.generated,
    required this.versionedAssets,
    required this.assetHashes,
    required this.manuallyVersionedFiles,
  });

  Map<String, dynamic> toJson() {
    return {
      'generated': generated,
      'versioned_assets': versionedAssets,
      'asset_hashes': assetHashes,
      'manually_versioned_files': manuallyVersionedFiles,
    };
  }
}
