import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

/// Represents Unique Document Type Identifier.
final class DocumentType extends Equatable {
  /// List of uuids. Order is important.
  final List<Uuid> value;

  /// Default constructor for the [DocumentType].
  const DocumentType(this.value);

  /// Deserializes the type from cbor.
  factory DocumentType.fromCbor(CborValue value) {
    // backwards compatibility but we're not going to maintain it as its pre 1.0
    if (value is CborBytes) {
      return DocumentType([Uuid.fromCbor(value)]);
    }

    if (value is CborList) {
      final types = value.map(Uuid.fromCbor).toList();
      return DocumentType(types);
    }

    throw ArgumentError.value(value, 'value', 'Not a supported value for DocumentType!');
  }

  @override
  List<Object?> get props => [value];

  /// Serializes the type as cbor.
  CborValue toCbor() {
    return CborList(value.map((e) => e.toCbor()).toList());
  }
}
