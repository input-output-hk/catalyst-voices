import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Defines singular profile used by [User]. One [User] may have multiple
/// [Profile]'s.
final class Profile extends Equatable {
  final Set<AccountRole> roles;

  const Profile({
    required this.roles,
  });

  @override
  List<Object?> get props => [
        roles,
      ];
}
