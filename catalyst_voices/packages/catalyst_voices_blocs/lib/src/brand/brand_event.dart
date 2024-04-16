part of 'brand_bloc.dart';

abstract final class BrandEvent extends Equatable {
  const BrandEvent();

  @override
  List<Object> get props => [];
}

final class BrandChanged extends BrandEvent {
  final BrandKey brand;

  const BrandChanged(this.brand);

  @override
  List<Object> get props => [brand];
}
