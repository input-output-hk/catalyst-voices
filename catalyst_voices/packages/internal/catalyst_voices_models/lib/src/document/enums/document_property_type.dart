/// The type of the document property.
enum DocumentPropertyType {
  /// A list of properties, new items might be added.
  list,

  /// A set of properties, new items cannot be added.
  ///
  /// Equivalent to an object with fields.
  object,

  /// A [String] property type without children.
  string,

  /// A [int] property type without children.
  integer,

  /// A [double] property type without children.
  number,

  /// A [boolean] property type without children.
  boolean;
}
