import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/cupertino.dart';

/// Strategy for fetching the available app version from mobile app stores (but can be extended to
/// stores available on windows or linux).
///
/// This is a stub implementation that will be completed once the mobile
/// version checking approach is decided (external package or direct API calls).
///
/// This can be split into separate iOS (AppStoreVersionSourceStrategy)
/// and Android (PlayStoreVersionSourceStrategy) implementations if needed.
// TODO(LynxLynxx): Implement mobile version checking with app store APIs or a external package
final class MobileVersionSourceStrategy implements VersionSourceStrategy {
  const MobileVersionSourceStrategy();

  @override
  Future<AppVersion> getAvailableVersion() async {
    throw UnimplementedError(
      'Mobile version checking is not yet implemented. '
      'TODO: Integrate with app store APIs or use a external package',
    );
  }
}

// ignore: one_member_abstracts
abstract interface class VersionSourceStrategy {
  const VersionSourceStrategy();

  Future<AppVersion> getAvailableVersion();
}

class VersionSourceStrategyFactory {
  const VersionSourceStrategyFactory();

  static VersionSourceStrategy getDefaultStrategyType({
    required SystemStatusRepository repository,
  }) {
    return getStrategy(type: CatalystOperatingSystem.current, repository: repository);
  }

  @visibleForTesting
  static VersionSourceStrategy getStrategy({
    required CatalystOperatingSystem type,
    required SystemStatusRepository repository,
  }) {
    return switch (type) {
      _ when CatalystPlatform.isWeb => WebVersionSourceStrategy(repository),
      _ => const MobileVersionSourceStrategy(),
    };
  }
}

/// Strategy for fetching the available app version from web endpoint.
final class WebVersionSourceStrategy implements VersionSourceStrategy {
  final SystemStatusRepository _repository;

  const WebVersionSourceStrategy(this._repository);

  @override
  Future<AppVersion> getAvailableVersion() async {
    try {
      return await _repository.currentAppVersion();
    } catch (e) {
      rethrow;
    }
  }
}
