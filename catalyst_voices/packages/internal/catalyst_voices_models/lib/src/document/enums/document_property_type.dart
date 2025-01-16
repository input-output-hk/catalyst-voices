/// The type of the document property.
enum DocumentPropertyType {
  /// A list of properties, new items might be added.
  list('array'),

  /// A set of properties, new items cannot be added.
  ///
  /// Equivalent to an object with fields.
  object('object'),

  /// A [String] property type without no children.
  string('string'),

  /// A [int] property type without no children.
  integer('integer'),

  /// A [double] property type without no children.
  number('number'),

  /// A [boolean] property type without no children.
  boolean('boolean');

  /// A string representation of the enum.
  final String value;

  const DocumentPropertyType(this.value);

  factory DocumentPropertyType.fromString(String string) {
    for (final type in values) {
      if (type.value.toLowerCase() == string.toLowerCase()) {
        return type;
      }
    }
    throw ArgumentError('Unsupported $string document property type');
  }
}
