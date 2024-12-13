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
