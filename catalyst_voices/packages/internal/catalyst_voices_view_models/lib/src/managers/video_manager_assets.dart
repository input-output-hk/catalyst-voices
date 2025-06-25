import 'package:equatable/equatable.dart';

/// Base class for video asset representations.
///
/// This class provides a common interface for video assets, including the asset's package name.
/// All video asset types should extend this class.
abstract class BaseVideoAsset extends Equatable {
  final String package;

  const BaseVideoAsset({
    this.package = 'catalyst_voices_assets',
  });

  @override
  List<Object?> get props => [package];
}

/// Represents a video cache key used to identify and manage a cached video asset.
class VideoCacheKey extends BaseVideoAsset {
  final String name;

  const VideoCacheKey({
    required this.name,
    super.package,
  });

  @override
  List<Object?> get props => [...super.props, name];

  VideoCacheKey copyWith({
    String? name,
    String? package,
  }) {
    return VideoCacheKey(
      name: name ?? this.name,
      package: package ?? this.package,
    );
  }
}

/// Represents a list of video assets to be precached.
class VideoPrecacheAssets extends BaseVideoAsset {
  final List<String> assets;

  const VideoPrecacheAssets({
    required this.assets,
    super.package,
  });

  @override
  List<Object?> get props => [...super.props, assets];

  VideoPrecacheAssets copyWith({
    List<String>? assets,
    String? package,
  }) {
    return VideoPrecacheAssets(
      assets: assets ?? this.assets,
      package: package ?? this.package,
    );
  }
}
