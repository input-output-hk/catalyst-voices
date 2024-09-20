part of 'brand_bloc.dart';

final class BrandState extends Equatable {
  final Brand brand;

  const BrandState({
    this.brand = Brand.catalyst,
  });

  @override
  List<Object> get props => [brand];
}
