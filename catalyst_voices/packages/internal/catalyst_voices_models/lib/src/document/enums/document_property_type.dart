enum DocumentPropertyType {
  list('array'),
  object('object'),
  string('string'),
  integer('integer'),
  number('number'),
  boolean('boolean');

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
