import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class PublicProfileEmailStatusState extends Equatable {
  final String? email;
  final bool isEmailVerified;
  final bool isProposer;
  final bool isVisible;

  const PublicProfileEmailStatusState({
    this.email,
    this.isEmailVerified = false,
    this.isProposer = false,
    this.isVisible = false,
  });

  @override
  List<Object?> get props => [email, isEmailVerified, isProposer, isVisible];

  bool get showDiscoveryEmailVerificationBanner {
    if (email == null) {
      return false;
    }

    final isEmailProvided = email?.isNotEmpty ?? false;

    if (isEmailProvided && !isEmailVerified && !isProposer) {
      return true;
    }

    return showProposerEmailVerificationBanner;
  }

  bool get showProposerEmailVerificationBanner {
    if (email == null) {
      return false;
    }
    if (isProposer && !isEmailVerified) {
      return true;
    }

    return false;
  }

  PublicProfileEmailStatusState copyWith({
    Optional<String>? email,
    bool? isEmailVerified,
    bool? isProposer,
    bool? isVisible,
  }) {
    return PublicProfileEmailStatusState(
      email: email?.dataOr(this.email),
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isProposer: isProposer ?? this.isProposer,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}
