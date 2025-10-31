import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Orders proposals based on their [Proposal.title] in alphabetical order.
final class Alphabetical extends ProposalsOrder {
  const Alphabetical();

  @override
  String toString() => 'Alphabetical';
}

/// Orders proposals based on their [Proposal.fundsRequested].
///
/// The sorting direction can be specified as ascending or descending.
final class Budget extends ProposalsOrder {
  /// Determines the sorting direction.
  ///
  /// If `true`, proposals are sorted from the lowest budget to the highest.
  /// If `false`, they are sorted from the highest budget to the lowest.
  final bool isAscending;

  const Budget({
    required this.isAscending,
  });

  @override
  List<Object?> get props => [isAscending];

  @override
  String toString() => 'Budget(${isAscending ? 'asc' : 'desc'})';
}

/// A base sealed class that defines different strategies for ordering a list of [Proposal] objects.
///
/// Subclasses of [ProposalsOrder] represent specific ordering methods,
/// such as by title, budget, or update date. This sealed class ensures that only a
/// predefined set of ordering types can be created, providing type safety.
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
