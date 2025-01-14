enum DocumentPropertyType {
  array,
  object,
  string,
  integer,
  number,
  boolean;

  static DocumentPropertyType fromString(String value) {
    final type = DocumentPropertyType.values.asNameMap()[value.toLowerCase()];
    if (type == null) {
      throw ArgumentError('Unsupported property type: $value');
    }
    return type;
  }
}
