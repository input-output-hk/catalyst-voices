import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/common/semantics/combine_semantics.dart';
import 'package:catalyst_voices/widgets/document_builder/common/document_property_builder_title.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

/// A view-mode for [DocumentBuilder] components.
class DocumentPropertyBuilderViewer extends StatefulWidget {
  final DocumentProperty property;
  final DocumentPropertyBuilderOverrides? overrides;

  const DocumentPropertyBuilderViewer({
    super.key,
    required this.property,
    this.overrides,
  });

  @override
  State<DocumentPropertyBuilderViewer> createState() {
    return _DocumentPropertyBuilderViewerState();
  }
}

class _DocumentPropertyBuilderViewerState extends State<DocumentPropertyBuilderViewer> {
  final List<Widget> _items = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: _items,
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

  Iterable<Widget> _buildListProperty(
    DocumentListProperty property,
  ) sync* {
    final schema = property.schema;
    yield _TextListItem(
      id: property.nodeId,
      title: schema.title,
      isRequired: schema.isRequired,
      value: schema.itemsSchema.title.formatAsPlural(property.properties.length),
    );

    for (final property in property.properties.whereNot(
      (element) => element.schema.isSectionOrSubsection,
    )) {
      yield* _buildProperty(property);
    }
  }

  Iterable<Widget> _buildObjectProperty(
    DocumentObjectProperty property,
  ) sync* {
    final schema = property.schema;
    switch (schema) {
      case DocumentSingleGroupedTagSelectorSchema():
        final value = schema.groupedTagsSelection(property);

        yield _TextListItem(
          id: property.nodeId,
          title: schema.title,
          isRequired: schema.isRequired,
          value: value?.toString(),
        );
      case DocumentSegmentSchema():
      case DocumentSectionSchema():
      case DocumentNestedQuestionsSchema():
      case DocumentBorderGroupSchema():
      case DocumentGenericObjectSchema():
        for (final property in property.properties.whereNot(
          (element) => element.schema.isSectionOrSubsection,
        )) {
          yield* _buildProperty(property);
        }
    }
  }

  Iterable<Widget> _buildProperty(DocumentProperty property) sync* {
    final overrideBuilder = _getOverrideBuilder(property.nodeId);
    if (overrideBuilder != null) {
      yield overrideBuilder(
        context,
        property,
        (
          editedData: null,
          isEditMode: false,
          onCollaboratorsChanged: (_) {},
        ),
      );
      return;
    }

    switch (property) {
      case DocumentListProperty():
        yield* _buildListProperty(property);
      case DocumentObjectProperty():
        yield* _buildObjectProperty(property);
      case DocumentValueProperty<Object>():
        yield Semantics(
          identifier: 'DocumentPropertyBuilderViewer[${property.nodeId}]',
          container: true,
          child: _buildValueProperty(property),
        );
    }
  }

  Widget _buildValueProperty(DocumentValueProperty property) {
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

        return _TextListItem(
          id: property.nodeId,
          title: schema.title,
          isRequired: schema.isRequired,
          value: text,
        );
      case DocumentCurrencySchema():
        final num = schema.castValue(value);
        final money = num != null ? schema.valueToMoney(num) : null;
        final text = money != null ? MoneyFormatter.formatDecimal(money) : null;

        return _TextListItem(
          id: property.nodeId,
          title: schema.title,
          isRequired: schema.isRequired,
          value: text,
        );
      case DocumentDurationInMonthsSchema():
        final months = schema.castValue(value);
        final text = months != null ? context.l10n.valueMonths(months) : null;

        return _TextListItem(
          id: property.nodeId,
          title: schema.title,
          isRequired: schema.isRequired,
          value: text,
        );
      case DocumentSingleLineHttpsUrlEntrySchema():
        final link = schema.castValue(value);

        return _TextListItem(
          id: property.nodeId,
          title: schema.title,
          isRequired: schema.isRequired,
          value: link,
          isLink: true,
        );
      case DocumentMultiLineTextEntrySchema():
        final text = schema.castValue(value);

        return _TextListItem(
          id: property.nodeId,
          title: schema.title,
          isRequired: schema.isRequired,
          value: text,
          isMultiline: true,
        );
      case DocumentMultiLineTextEntryMarkdownSchema():
        final text = schema.castValue(value);
        final data = text != null ? MarkdownData(text) : null;

        return _MarkdownListItem(
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

        return _TextListItem(
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
        return _TextListItem(
          id: property.nodeId,
          title: schema.title,
          isRequired: schema.isRequired,
          value: value?.toString(),
        );
    }
  }

  DocumentPropertyWidgetBuilder? _getOverrideBuilder(DocumentNodeId nodeId) {
    final overrides = widget.overrides;
    if (overrides == null) return null;

    return overrides[nodeId];
  }

  void _updateItems() {
    _items
      ..clear()
      ..addAll(_buildProperty(widget.property));
  }
}

class _ListItem extends StatelessWidget {
  final String title;
  final bool isRequired;
  final bool isMultiline;
  final bool isAnswered;
  final Widget child;

  const _ListItem({
    required super.key,
    required this.title,
    required this.isRequired,
    this.isMultiline = false,
    this.isAnswered = false,
    required this.child,
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
            color: isAnswered ? colors.textOnPrimaryLevel1 : colors.textOnPrimaryLevel0,
          ),
          const SizedBox(height: 8),
        ],
        CombineSemantics(
          identifier: 'DocumentPropertyBuilderViewerListItem',
          container: true,
          child: DefaultTextStyle(
            style: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
              color: isAnswered ? colors.textOnPrimaryLevel0 : colors.textOnPrimaryLevel1,
            ),
            maxLines: !isMultiline ? 1 : null,
            overflow: !isMultiline ? TextOverflow.ellipsis : TextOverflow.clip,
            child: child,
          ),
        ),
      ],
    );
  }
}

class _MarkdownListItem extends StatelessWidget {
  final DocumentNodeId id;
  final String title;
  final bool isRequired;
  final MarkdownData? value;

  const _MarkdownListItem({
    required this.id,
    required this.title,
    required this.isRequired,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    final isAnswered = value != null && value.data.isNotBlank;

    final Widget child;
    if (!isAnswered) {
      child = Text(context.l10n.proposalEditorNotAnswered);
    } else {
      child = MarkdownText(value);
    }

    return _ListItem(
      key: ValueKey(id),
      title: title,
      isRequired: isRequired,
      isAnswered: isAnswered,
      isMultiline: true,
      child: child,
    );
  }
}

class _TextListItem extends StatelessWidget {
  final DocumentNodeId id;
  final String title;
  final bool isRequired;
  final String? value;
  final bool isLink;
  final bool isMultiline;

  const _TextListItem({
    required this.id,
    required this.title,
    required this.isRequired,
    required this.value,
    this.isLink = false,
    this.isMultiline = false,
  });

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    final isAnswered = value != null && value.isNotBlank;

    final Widget child;
    if (!isAnswered) {
      child = Text(context.l10n.proposalEditorNotAnswered);
    } else if (isLink) {
      child = LinkText(value);
    } else {
      child = Text(value);
    }

    return _ListItem(
      key: ValueKey(id),
      title: title,
      isRequired: isRequired,
      isMultiline: isMultiline,
      isAnswered: isAnswered,
      child: child,
    );
  }
}
