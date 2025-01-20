import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:json_annotation/json_annotation.dart';

final class DurationConverter implements JsonConverter<Duration, int> {
  const DurationConverter();

  @override
  Duration fromJson(int json) => Duration(seconds: json);

  @override
  int toJson(Duration object) => object.inSeconds;
}

final class CoinConverter implements JsonConverter<Coin, int> {
  const CoinConverter();

  @override
  Coin fromJson(int json) => Coin(json);

  @override
  int toJson(Coin object) => object.value;
}

final class ShelleyAddressConverter
    implements JsonConverter<ShelleyAddress, String> {
  const ShelleyAddressConverter();

  @override
  ShelleyAddress fromJson(String json) => ShelleyAddress.fromBech32(json);

  @override
  String toJson(ShelleyAddress object) => object.toBech32();
}

/// A converter that only casts json to a target type.
///
/// Can be used for simple types like [String], [int], etc,
/// which have a direct representation in json.
final class NoopConverter<T> implements JsonConverter<T?, Object?> {
  const NoopConverter();

  @override
  T? fromJson(Object? json) => json as T?;

  @override
  Object? toJson(T? object) => object as Object?;
}
