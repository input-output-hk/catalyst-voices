import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Orders representatives by their [CatalystId.username].
final class RepresentativesAlphabeticalOrder extends RepresentativesOrder {
  const RepresentativesAlphabeticalOrder();

  @override
  String toString() => 'Alphabetical';
}

/// Base class for defining the order of representatives.
sealed class RepresentativesOrder extends Equatable {
  /// Creates a [RepresentativesOrder].
  const RepresentativesOrder();

  @override
  List<Object?> get props => [];
}

/// Orders representatives randomly.
final class RepresentativesRandomOrder extends RepresentativesOrder {
  const RepresentativesRandomOrder();

  @override
  String toString() => 'Random';
}
