import 'package:catalyst_voices/widgets/document_builder/common/document_error_text.dart';
import 'package:catalyst_voices/widgets/document_builder/common/document_property_builder_title.dart';
import 'package:catalyst_voices/widgets/document_builder/value/document_builder_value_widget.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart' hide DocumentPropertyBuilder;
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class DocumentObjectPropertyBuilder extends StatelessWidget {
  final DocumentObjectProperty property;
  final bool isEditMode;
  final ValueChanged<List<DocumentChange>> onChanged;
  final CollaboratorsSectionData collaboratorsSectionData;
  final DocumentPropertyBuilderOverrides? overrides;

  const DocumentObjectPropertyBuilder({
    super.key,
    required this.property,
    required this.isEditMode,
    required this.onChanged,
    required this.collaboratorsSectionData,
    this.overrides,
  });

  @override
  Widget build(BuildContext context) {
    final schema = property.schema;

    switch (schema) {
      case DocumentSingleGroupedTagSelectorSchema():
        return SingleGroupedTagSelectorWidget(
          schema: schema,
          property: property,
          isEditMode: isEditMode,
          onChanged: onChanged,
        );

      case DocumentSegmentSchema():
      case DocumentSectionSchema():
      case DocumentNestedQuestionsSchema():
      case DocumentGenericObjectSchema():
      case DocumentBorderGroupSchema():
        return _GenericDocumentObjectPropertyBuilder(
          schema: schema,
          property: property,
          isEditMode: isEditMode,
          onChanged: onChanged,
          collaboratorsSectionData: collaboratorsSectionData,
          overrides: overrides,
        );
    }
  }
}

class _FormField extends VoicesFormField<DocumentObjectProperty> {
  _FormField({
    required super.value,
    super.validator,
    super.autovalidateMode,
    required bool isEditMode,
    required ValueChanged<List<DocumentChange>> onDocumentChanged,
    required CollaboratorsSectionData collaboratorsSectionData,
    required DocumentPropertyBuilderOverrides? overrides,
  }) : super(
         enabled: isEditMode,
         builder: (field) {
           final context = field.context;
           final property = field.value!;
           final schema = property.schema;
           final title = schema.title;
           final properties = property.properties.whereNot(
             (child) => child.schema.isSectionOrSubsection,
           );

           final showBorder = schema is DocumentBorderGroupSchema;
           final error = field.errorText;

           return Container(
             width: double.infinity,
             padding: showBorder ? const EdgeInsets.all(16) : null,
             decoration: showBorder
                 ? BoxDecoration(
                     border: Border.all(color: Theme.of(context).dividerColor),
                     borderRadius: BorderRadius.circular(8),
                   )
                 : null,
             child: Column(
               mainAxisSize: MainAxisSize.min,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 if (title.isNotEmpty && !schema.isSectionOrSubsection) ...[
                   DocumentPropertyBuilderTitle(
                     title: title,
                     isRequired: false,
                   ),
                   const SizedBox(height: 8),
                 ],
                 ...properties
                     .map<Widget>((child) {
                       return DocumentPropertyBuilder(
                         key: ValueKey(child.nodeId),
                         property: child,
                         isEditMode: isEditMode,
                         onChanged: onDocumentChanged,
                         collaboratorsSectionData: collaboratorsSectionData,
                         overrides: overrides,
                       );
                     })
                     .separatedBy(const SizedBox(height: 24)),
                 if (error != null) ...[
                   if (properties.isNotEmpty) const SizedBox(height: 4),
                   DocumentErrorText(
                     text: error,
                     enabled: isEditMode,
                   ),
                 ],
               ],
             ),
           );
         },
       );
}

class _GenericDocumentObjectPropertyBuilder extends StatefulWidget {
  final DocumentObjectSchema schema;
  final DocumentObjectProperty property;
  final bool isEditMode;
  final ValueChanged<List<DocumentChange>> onChanged;
  final CollaboratorsSectionData collaboratorsSectionData;
  final DocumentPropertyBuilderOverrides? overrides;

  const _GenericDocumentObjectPropertyBuilder({
    required this.schema,
    required this.property,
    required this.isEditMode,
    required this.onChanged,
    required this.collaboratorsSectionData,
    this.overrides,
  });

  @override
  State<_GenericDocumentObjectPropertyBuilder> createState() =>
      _GenericDocumentObjectPropertyBuilderState();
}

class _GenericDocumentObjectPropertyBuilderState
    extends State<_GenericDocumentObjectPropertyBuilder> {
  AutovalidateMode _autovalidateMode = AutovalidateMode.onUserInteraction;

  @override
  Widget build(BuildContext context) {
    return _FormField(
      value: widget.property,
      validator: (property) => _validator(context, property),
      autovalidateMode: _autovalidateMode,
      isEditMode: widget.isEditMode,
      onDocumentChanged: _onDocumentChanged,
      collaboratorsSectionData: widget.collaboratorsSectionData,
      overrides: widget.overrides,
    );
  }

  void _onDocumentChanged(List<DocumentChange> changes) {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });
    widget.onChanged(changes);
  }

  String? _validator(BuildContext context, DocumentObjectProperty? property) {
    if (property == null) {
      return null;
    }

    return LocalizedDocumentValidationResult.from(property.validationResult).message(context);
  }
}
