import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Orders representatives by their [CatalystId.username].
final class RepresentativesAlphabetical extends RepresentativesOrder {
  const RepresentativesAlphabetical();

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
final class RepresentativesRandom extends RepresentativesOrder {
  const RepresentativesRandom();

  @override
  String toString() => 'Random';
}
