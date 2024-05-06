part of 'brand_bloc.dart';

sealed class BrandEvent extends Equatable {
  const BrandEvent();

  @override
  List<Object> get props => [];
}

final class BrandChangedEvent extends BrandEvent {
  final BrandKey brand;

  const BrandChangedEvent(this.brand);

  @override
  List<Object> get props => [brand];
}
