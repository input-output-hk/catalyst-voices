import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

final class Representative extends Equatable {
  final CatalystId id;
  final RepresentativeProfile profile;
  final List<RepresentativeNomination> nominations;

  const Representative({
    required this.id,
    required this.profile,
    this.nominations = const [],
  });

  bool get isValid {
    return !profile.isRevoked &&
        nominations.isNotEmpty &&
        nominations.none((nomination) => nomination.isRevoked);
  }

  @override
  List<Object?> get props => [
    id,
    profile,
    nominations,
  ];

  Representative copyWith({
    CatalystId? id,
    RepresentativeProfile? profile,
    List<RepresentativeNomination>? nominations,
  }) {
    return Representative(
      id: id ?? this.id,
      profile: profile ?? this.profile,
      nominations: nominations ?? this.nominations,
    );
  }
}
