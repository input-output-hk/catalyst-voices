import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/document_builder/common/document_property_builder_title.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

/// A view-mode for [DocumentBuilder] components.
class DocumentPropertyBuilderViewer extends StatefulWidget {
  final DocumentProperty property;

  const DocumentPropertyBuilderViewer({
    super.key,
    required this.property,
  });

  @override
  State<DocumentPropertyBuilderViewer> createState() {
    return _DocumentPropertyBuilderViewerState();
  }
}

class _DocumentPropertyBuilderViewerState
    extends State<DocumentPropertyBuilderViewer> {
  final List<DocumentPropertyValueListItem<Object>> _items = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        for (final item in _items)
          _ListItemBuilder(
            key: ObjectKey(item.id),
            item: item,
          ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // rebuild items because some of values depends on l10n which may
    // have changed.
    _updateItems();
  }

  @override
  void didUpdateWidget(DocumentPropertyBuilderViewer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.property != oldWidget.property) {
      _updateItems();
    }
  }

  Iterable<DocumentPropertyValueListItem<Object>> _calculateItemsFrom(
    DocumentProperty property,
  ) sync* {
    switch (property) {
      case DocumentListProperty():
        yield* _calculateItemsFromList(property);
      case DocumentObjectProperty():
        yield* _calculateItemsFromObject(property);
      case DocumentValueProperty<Object>():
        yield _mapDocumentPropertyToListItem(property);
    }
  }

  Iterable<DocumentPropertyValueListItem<Object>> _calculateItemsFromList(
    DocumentListProperty property,
  ) sync* {
    final schema = property.schema;
    yield DocumentTextListItem(
      id: property.nodeId,
      title: schema.title,
      isRequired: schema.isRequired,
      value:
          schema.itemsSchema.title.formatAsPlural(property.properties.length),
    );

    for (final property in property.properties
        .whereNot((element) => element.schema.isSectionOrSubsection)) {
      yield* _calculateItemsFrom(property);
    }
  }

  Iterable<DocumentPropertyValueListItem<Object>> _calculateItemsFromObject(
    DocumentObjectProperty property,
  ) sync* {
    final schema = property.schema;
    switch (schema) {
      case DocumentSingleGroupedTagSelectorSchema():
        final value = schema.groupedTagsSelection(property);

        yield DocumentTextListItem(
          id: property.nodeId,
          title: '',
          isRequired: schema.isRequired,
          value: value?.toString(),
        );
      case DocumentSegmentSchema():
      case DocumentSectionSchema():
      case DocumentNestedQuestionsSchema():
      case DocumentBorderGroupSchema():
      case DocumentGenericObjectSchema():
        for (final property in property.properties
            .whereNot((element) => element.schema.isSectionOrSubsection)) {
          yield* _calculateItemsFrom(property);
        }
    }
  }

  DocumentPropertyValueListItem<Object> _mapDocumentPropertyToListItem(
    DocumentValueProperty property,
  ) {
    final schema = property.schema;
    final value = property.value;

    switch (schema) {
      case DocumentAgreementConfirmationSchema():
      case DocumentGenericBooleanSchema():
      case DocumentYesNoChoiceSchema():
        final answer = value is bool ? value : null;
        final text = answer != null
            ? answer
                ? context.l10n.yes
                : context.l10n.no
            : null;

        return DocumentTextListItem(
          id: property.nodeId,
          title: schema.title,
          isRequired: schema.isRequired,
          value: text,
        );
      case DocumentTokenValueCardanoAdaSchema():
        final num = schema.castValue(value);
        final text = num != null ? const Currency.ada().format(num) : null;

        return DocumentTextListItem(
          id: property.nodeId,
          title: schema.title,
          isRequired: schema.isRequired,
          value: text,
        );
      case DocumentDurationInMonthsSchema():
        final months = schema.castValue(value);
        final text = months != null ? context.l10n.valueMonths(months) : null;

        return DocumentTextListItem(
          id: property.nodeId,
          title: schema.title,
          isRequired: schema.isRequired,
          value: text,
        );
      case DocumentSingleLineHttpsUrlEntrySchema():
        final link = schema.castValue(value);

        return DocumentLinkReadItem(
          id: property.nodeId,
          title: schema.title,
          isRequired: schema.isRequired,
          value: link,
        );
      case DocumentMultiLineTextEntrySchema():
        final text = schema.castValue(value);

        return DocumentTextListItem(
          id: property.nodeId,
          title: schema.title,
          isRequired: schema.isRequired,
          value: text,
          isMultiline: true,
        );
      case DocumentMultiLineTextEntryMarkdownSchema():
        final text = schema.castValue(value);
        final data = text != null ? MarkdownData(text) : null;

        return DocumentMarkdownListItem(
          id: property.nodeId,
          title: schema.title,
          isRequired: schema.isRequired,
          value: data,
        );
      case DocumentTagGroupSchema():
      case DocumentTagSelectionSchema():
        throw ArgumentError('$property can not be mapped on its own');
      case DocumentLanguageCodeSchema():
        final code = schema.castValue(value);
        final localeNames = LocaleNames.of(context);
        final text = code != null ? localeNames?.nameOf(code) : null;

        return DocumentTextListItem(
          id: property.nodeId,
          title: schema.title,
          isRequired: schema.isRequired,
          value: text,
        );
      case DocumentDropDownSingleSelectSchema():
      case DocumentGenericIntegerSchema():
      case DocumentGenericNumberSchema():
      case DocumentSingleLineTextEntrySchema():
      case DocumentRadioButtonSelect():
      case DocumentGenericStringSchema():
        return DocumentTextListItem(
          id: property.nodeId,
          title: schema.title,
          isRequired: schema.isRequired,
          value: value?.toString(),
        );
    }
  }

  void _updateItems() {
    _items
      ..clear()
      ..addAll(_calculateItemsFrom(widget.property));
  }
}

class _ListItem extends StatelessWidget {
  final String title;
  final bool isRequired;
  final Widget value;
  final bool isMultiline;
  final bool isAnswered;

  const _ListItem({
    required this.title,
    required this.isRequired,
    required this.value,
    this.isMultiline = false,
    this.isAnswered = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Note. Links are single line https entry but do not have title
        if (title.isNotEmpty) ...[
          DocumentPropertyBuilderTitle(
            title: title,
            isRequired: isRequired,
            color: isAnswered
                ? colors.textOnPrimaryLevel1
                : colors.textOnPrimaryLevel0,
          ),
          const SizedBox(height: 8),
        ],
        DefaultTextStyle(
          style: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
            color: isAnswered
                ? colors.textOnPrimaryLevel0
                : colors.textOnPrimaryLevel1,
          ),
          maxLines: !isMultiline ? 1 : null,
          overflow: !isMultiline ? TextOverflow.ellipsis : TextOverflow.clip,
          child: value,
        ),
      ],
    );
  }
}

class _ListItemBuilder extends StatelessWidget {
  final DocumentPropertyValueListItem<Object> item;

  const _ListItemBuilder({
    required super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return switch (item) {
      DocumentLinkReadItem(:final value) => _ListItem(
          title: item.title,
          isRequired: item.isRequired,
          value: value != null
              ? LinkText(value)
              : Text(context.l10n.proposalEditorNotAnswered),
          isMultiline: true,
          isAnswered: value != null,
        ),
      DocumentMarkdownListItem(:final value) => _ListItem(
          title: item.title,
          isRequired: item.isRequired,
          value: (value != null && value.data.isNotBlank)
              ? MarkdownText(value)
              : Text(context.l10n.proposalEditorNotAnswered),
          isMultiline: true,
          isAnswered: value != null && value.data.isNotBlank,
        ),
      DocumentTextListItem(:final value, :final isMultiline) => _ListItem(
          title: item.title,
          isRequired: item.isRequired,
          value: Text(value ?? context.l10n.proposalEditorNotAnswered),
          isMultiline: isMultiline,
          isAnswered: value != null,
        ),
    };
  }
}
