part of 'brand_bloc.dart';

final class BrandState extends Equatable {
  final BrandKey? brandKey;

  const BrandState({BrandKey? brandKey})
    : brandKey = brandKey ?? BrandKey.catalyst;

  @override
  List<Object> get props => [brandKey ?? ''];
}
