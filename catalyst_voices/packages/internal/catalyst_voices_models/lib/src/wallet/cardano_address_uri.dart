import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:equatable/equatable.dart';

/// A format of web+cardano uri holding a [ShelleyAddress].
final class CardanoAddressUri extends Equatable {
  static const _prefix = 'web+cardano://addr/';

  /// A [ShelleyAddress] this uri points to.
  final ShelleyAddress address;

  /// A default constructor for the [CardanoAddressUri].
  const CardanoAddressUri(this.address);

  /// Deserialized the [CardanoAddressUri] from [uri].
  factory CardanoAddressUri.fromString(String uri) {
    final index = uri.indexOf(_prefix);
    if (index < 0) {
      throw ArgumentError.value(
        uri,
        'uri',
        'Is not a valid $CardanoAddressUri',
      );
    }
    final bech32 = uri.substring(index + _prefix.length);
    final address = ShelleyAddress.fromBech32(bech32);
    return CardanoAddressUri(address);
  }

  @override
  List<Object?> get props => [address];

  @override
  String toString() => _prefix + address.toBech32();

  /// Whether the [uri] is following the format of [CardanoAddressUri].
  static bool isCardanoAddressUri(String uri) {
    return uri.contains(_prefix);
  }
}
