import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Profile is a representation of [Account] from perspective of other users.
/// For example of what user knows about other [Account] when viewing
/// proposal.
final class Profile extends Equatable {
  final CatalystId catalystId;

  const Profile({
    required this.catalystId,
  });

  @override
  List<Object?> get props => [
        catalystId,
      ];

  String? get username => catalystId.username;
}
