part of 'brand_bloc.dart';

final class BrandState extends Equatable {
  final ThemeData? themeData;

  BrandState({ThemeData? themeData})
    : themeData = themeData ?? brands[BrandKey.catalyst];

  @override
  List<Object> get props => [themeData ?? ''];
}
