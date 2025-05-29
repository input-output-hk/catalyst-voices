import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Orders base on [Proposal.title].
final class Alphabetical extends ProposalsOrder {
  const Alphabetical();
}

/// Order base on [Proposal.fundsRequested].
///
/// The [isAscending] parameter determines the direction of the sort:
/// - true: Lowest budget to highest budget.
/// - false: Highest budget to lowest budget.
final class Budget extends ProposalsOrder {
  final bool isAscending;

  const Budget({
    required this.isAscending,
  });

  @override
  List<Object?> get props => [isAscending];
}

/// A base sealed class representing different ways to order [Proposal].
///
/// This allows us to define a fixed set of ordering types,
/// where each type can potentially hold its own specific data or logic.
sealed class ProposalsOrder extends Equatable {
  const ProposalsOrder();

  @override
  List<Object?> get props => [];
}

/// Orders base on [Proposal] version.
///
/// The [isAscending] parameter determines the direction of the sort:
/// - true: Oldest to newest.
/// - false: Newest to oldest.
final class UpdateDate extends ProposalsOrder {
  final bool isAscending;

  const UpdateDate({
    required this.isAscending,
  });

  @override
  List<Object?> get props => [isAscending];
}
