import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// A container for the total funding asked by proposals, organized by templates.
///
/// The [data] map uses a [DocumentRef] (representing a template) as the key
/// and a [ProposalsTotalAskPerTemplate] object as the value.
final class ProposalsTotalAsk extends Equatable {
  /// A map where each key is a reference to a template document and
  /// the value contains the aggregated ask data for that template's proposals.
  final Map<DocumentRef, ProposalsTotalAskPerTemplate> data;

  const ProposalsTotalAsk(this.data);

  @override
  List<Object?> get props => [
    data,
  ];
}

/// Represents the aggregated funding information for proposals
/// within a single template.
final class ProposalsTotalAskPerTemplate extends Equatable {
  /// The sum of the `amountAsked` for all final proposals in a template.
  final int totalAsk;

  /// The total number of final proposals counted in a template.
  final int finalProposalsCount;

  /// Creates an instance of [ProposalsTotalAskPerTemplate].
  ///
  /// Both [totalAsk] and [finalProposalsCount] are required.
  const ProposalsTotalAskPerTemplate({
    required this.totalAsk,
    required this.finalProposalsCount,
  });

  @override
  List<Object?> get props => [
    totalAsk,
    finalProposalsCount,
  ];
}
