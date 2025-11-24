import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Orders base on [Proposal.title].
final class Alphabetical extends ProposalsOrder {
  const Alphabetical();

  @override
  String toString() => 'Alphabetical';
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

  @override
  String toString() => 'Budget(${isAscending ? 'asc' : 'desc'})';
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

/// Orders proposals based on their last update date, which corresponds to the [Proposal] version.
///
/// The sorting direction can be specified as ascending (oldest to newest)
/// or descending (newest to oldest).
final class UpdateDate extends ProposalsOrder {
  /// Determines the sorting direction.
  ///
  /// If `true`, proposals are sorted from oldest to newest.
  /// If `false`, they are sorted from newest to oldest.
  final bool isAscending;

  /// Creates an instance of [UpdateDate] order.
  ///
  /// The [isAscending] parameter is required to specify the sorting direction.
  const UpdateDate({
    required this.isAscending,
  });

  /// Creates an instance that sorts proposals in ascending order (oldest to newest).
  const UpdateDate.asc() : this(isAscending: true);

  /// Creates an instance that sorts proposals in descending order (newest to oldest).
  const UpdateDate.desc() : this(isAscending: false);

  @override
  List<Object?> get props => [isAscending];

  @override
  String toString() => 'UpdateDate(${isAscending ? 'asc' : 'desc'})';
}
