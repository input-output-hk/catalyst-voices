abstract class PropTemplateBase {
  final String ref;
  final String title;
  final String description;

  const PropTemplateBase({
    required this.ref,
    required this.title,
    required this.description,
  });
}

abstract class PropTemplateProperty<T> extends PropTemplateBase {
  final List<T> properties;

  const PropTemplateProperty({
    required super.ref,
    required super.title,
    required super.description,
    required this.properties,
  });
}

abstract class PropTemplateTopic {
  final String ref;
  final String title;

  const PropTemplateTopic({
    required this.ref,
    required this.title,
  });
}
