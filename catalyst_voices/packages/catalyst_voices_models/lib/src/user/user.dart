import 'package:catalyst_voices_models/src/user/profile.dart';
import 'package:equatable/equatable.dart';

/// Defines user or the app.
final class User extends Equatable {
  final List<Profile> profiles;

  User({
    required Profile profile,
  }) : profiles = [profile];

  /// Just syntax sugar for [activeProfile].
  Profile get profile => activeProfile;

  // Note. At the moment we support only single profile Users but later
  // this may change and this implementation with it.
  Profile get activeProfile => profiles.single;

  // Note. this is not defined yet what we will show here.
  String get acronym => 'A';

  @override
  List<Object?> get props => [
        profiles,
      ];
}
