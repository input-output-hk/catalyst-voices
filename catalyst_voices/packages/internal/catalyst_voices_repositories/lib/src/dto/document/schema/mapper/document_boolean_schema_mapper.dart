import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_definitions_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_property_schema_dto.dart';

enum _DocumentBooleanDefinition {
  yesNoChoice('yesNoChoice'),
  agreementConfirmation('agreementConfirmation'),
  unknown('unknown');

  final String def;

  const _DocumentBooleanDefinition(this.def);

  factory _DocumentBooleanDefinition.fromDef(String? def) {
    for (final value in values) {
      if (value.def.toLowerCase() == def?.toLowerCase()) {
        return value;
      }
    }

    return _DocumentBooleanDefinition.unknown;
  }
}

final class DocumentBooleanSchemaMapper {
  static DocumentBooleanSchema toModel({
    required DocumentDefinitionsDto definitions,
    required DocumentPropertySchemaDto schema,
    required DocumentNodeId nodeId,
    required bool isRequired,
  }) {
    final title = schema.title ?? '';
    final defaultValue = schema.defaultValue as bool?;
    final enumValues = schema.enumValues?.cast<bool>();
    final definition = _DocumentBooleanDefinition.fromDef(schema.definition());

    switch (definition) {
      case _DocumentBooleanDefinition.yesNoChoice:
        return DocumentYesNoChoiceSchema(
          nodeId: nodeId,
          title: title,
          description: schema.description,
          isRequired: isRequired,
          defaultValue: defaultValue,
          enumValues: enumValues,
        );
      case _DocumentBooleanDefinition.agreementConfirmation:
        return DocumentAgreementConfirmationSchema(
          nodeId: nodeId,
          title: title,
          description: schema.description,
          isRequired: isRequired,
          defaultValue: defaultValue,
          enumValues: enumValues,
        );
      case _DocumentBooleanDefinition.unknown:
        return DocumentGenericBooleanSchema(
          nodeId: nodeId,
          title: title,
          description: schema.description,
          isRequired: isRequired,
          defaultValue: defaultValue,
          enumValues: enumValues,
        );
    }
  }
}
