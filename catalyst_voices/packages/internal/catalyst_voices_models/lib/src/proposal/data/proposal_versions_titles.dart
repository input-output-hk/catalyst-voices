import 'package:equatable/equatable.dart';

/// Represents a collection of proposal versions and their associated titles
/// organized by proposal identifier.
final class ProposalVersionsTitles extends Equatable {
  /// A map where each key is a proposal identifier and the value contains
  /// the versions and titles for that proposal.
  final Map<String, VersionsTitles> proposalVersions;

  const ProposalVersionsTitles(this.proposalVersions);

  const ProposalVersionsTitles.empty() : proposalVersions = const {};

  @override
  List<Object?> get props => [proposalVersions];
}

/// Represents the version-to-title mappings for a single proposal.
///
/// This class contains the relationship between different versions of a proposal
/// and their corresponding titles.
final class VersionsTitles extends Equatable {
  /// A map where each key is a version identifier and the value is the title
  /// for that specific version. The title can be null.
  final Map<String, String?> data;

  const VersionsTitles(this.data);

  const VersionsTitles.empty() : data = const {};


  @override
  List<Object?> get props => [data];
}
