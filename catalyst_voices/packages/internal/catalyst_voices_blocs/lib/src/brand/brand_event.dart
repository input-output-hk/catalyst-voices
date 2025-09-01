part of 'brand_bloc.dart';

final class BrandChangedEvent extends BrandEvent {
  final Brand brand;

  const BrandChangedEvent(this.brand);

  @override
  List<Object> get props => [brand];
}

sealed class BrandEvent extends Equatable {
  const BrandEvent();

  @override
  List<Object> get props => [];
}
