import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Representative is an account with public representative profile and has nominations
/// for contests(categories).
///
/// Right now publishing representative profile means publishing nominations
/// for all categories of campaign.
final class Representative extends Equatable {
  /// The catId of the representative (account).
  final CatalystId id;

  /// Ref of profile document.
  final DocumentRef profileId;

  /// Value of profile document description property.
  final String description;

  const Representative({
    required this.id,
    required this.profileId,
    required this.description,
  });

  @override
  List<Object?> get props => [
    id,
    profileId,
    description,
  ];

  Representative copyWith({
    CatalystId? id,
    DocumentRef? profileId,
    String? description,
  }) {
    return Representative(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      description: description ?? this.description,
    );
  }
}
