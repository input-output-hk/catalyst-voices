import 'package:equatable/equatable.dart';

final class MaxDelegationRepresentativesReachedException extends Equatable implements Exception {
  final int max;

  const MaxDelegationRepresentativesReachedException({
    required this.max,
  });

  @override
  List<Object?> get props => [max];

  @override
  String toString() => 'Max number of representatives($max) per delegation is reached';
}
