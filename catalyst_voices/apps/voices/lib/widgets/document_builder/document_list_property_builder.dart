import 'package:catalyst_voices/widgets/document_builder/common/document_error_text.dart';
import 'package:catalyst_voices/widgets/document_builder/value/document_builder_value_widget.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart' hide DocumentPropertyBuilder;
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class DocumentListPropertyBuilder extends StatefulWidget {
  final DocumentListProperty property;
  final bool isEditMode;
  final ValueChanged<List<DocumentChange>> onChanged;
  final CollaboratorsSectionData collaboratorsSectionData;
  final DocumentPropertyBuilderOverrides? overrides;

  const DocumentListPropertyBuilder({
    super.key,
    required this.property,
    required this.isEditMode,
    required this.onChanged,
    required this.collaboratorsSectionData,
    this.overrides,
  });

  @override
  State<DocumentListPropertyBuilder> createState() => _DocumentListPropertyBuilderState();
}

class _DocumentListPropertyBuilderState extends State<DocumentListPropertyBuilder> {
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

  String? _validator(BuildContext context, DocumentListProperty? property) {
    if (property == null) {
      return null;
    }

    return LocalizedDocumentValidationResult.from(property.validationResult).message(context);
  }
}

class _FormField extends VoicesFormField<DocumentListProperty> {
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
           final property = field.value!;
           final properties = property.properties.whereNot(
             (child) => child.schema.isSectionOrSubsection,
           );

           final error = field.errorText;

           return Column(
             mainAxisSize: MainAxisSize.min,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               ...[
                 ListLengthPickerWidget(
                   key: ValueKey(property.nodeId),
                   list: property,
                   isEditMode: isEditMode,
                   onChanged: onDocumentChanged,
                 ),
                 ...properties.map<Widget>((child) {
                   return DocumentPropertyBuilder(
                     key: ValueKey(child.nodeId),
                     property: child,
                     isEditMode: isEditMode,
                     onChanged: onDocumentChanged,
                     collaboratorsSectionData: collaboratorsSectionData,
                     overrides: overrides,
                   );
                 }),
               ].separatedBy(const SizedBox(height: 24)),
               if (error != null) ...[
                 const SizedBox(height: 4),
                 DocumentErrorText(
                   text: error,
                   enabled: isEditMode,
                 ),
               ],
             ],
           );
         },
       );
}
