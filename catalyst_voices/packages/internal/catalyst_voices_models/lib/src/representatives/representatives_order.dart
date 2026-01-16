import 'package:equatable/equatable.dart';

sealed class RepresentativesOrder extends Equatable {
  const RepresentativesOrder();

  @override
  List<Object?> get props => [];
}

final class RepresentativesOrderUpdateDate extends RepresentativesOrder {
  final bool isAscending;

  const RepresentativesOrderUpdateDate({
    required this.isAscending,
  });

  const RepresentativesOrderUpdateDate.asc() : this(isAscending: true);

  const RepresentativesOrderUpdateDate.desc() : this(isAscending: false);

  @override
  List<Object?> get props => [isAscending];

  @override
  String toString() => 'RepresentativesOrderUpdateDate(${isAscending ? 'asc' : 'desc'})';
}
