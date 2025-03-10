import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Profile is a representation of [Account] from perspective of other users.
/// For example of what user knows about other [Account] when viewing
/// proposal.
final class Profile extends Equatable {
  // TODO(damian-molinski): this should be an URI
  // https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/rbac_id_uri/catalyst-id-uri/
  final String catalystId;

  const Profile({
    required this.catalystId,
  });

  // TODO(damian-molinski): Extract from catalystId
  String? get displayName => 'Dev';

  @override
  List<Object?> get props => [
        catalystId,
      ];
}
