import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

/// A callback that builds a widget for given [listItem].
typedef DocumentPropertyReadListItemBuilder = Widget Function(
  BuildContext context,
  DocumentPropertyValueListItem<Object> listItem,
);

/// A map defining overrides for [DocumentPropertyReadBuilder].
typedef DocumentPropertyReadOverrides = Map<DocumentNodeId, DocumentPropertyReadListItemBuilder>;

/// Renders single document property in read only way. Commonly used for proposal view + comments.
class DocumentPropertyReadBuilder extends StatefulWidget {
  final DocumentProperty property;
  final DocumentPropertyReadOverrides overrides;

  const DocumentPropertyReadBuilder({
    super.key,
    required this.property,
    this.overrides = const {},
  });

  @override
  State<DocumentPropertyReadBuilder> createState() {
    return _DocumentPropertyReadBuilderState();
  }
}

class _DocumentPropertyReadBuilderListTile extends StatelessWidget {
  final String title;
  final bool isMultiline;
  final Widget child;

  const _DocumentPropertyReadBuilderListTile({
    required super.key,
    required this.title,
    this.isMultiline = false,
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
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: colors.textOnPrimaryLevel1,
            ),
          ),
          const SizedBox(height: 2),
        ],
        DefaultTextStyle(
          style: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
            color: colors.textOnPrimaryLevel0,
          ),
          maxLines: !isMultiline ? 1 : null,
          overflow: !isMultiline ? TextOverflow.ellipsis : TextOverflow.clip,
          child: child,
        ),
      ],
    );
  }
}

class _DocumentPropertyReadBuilderListTileBuilder extends StatelessWidget {
  final DocumentPropertyValueListItem<Object> item;
  final DocumentPropertyReadOverrides overrides;

  const _DocumentPropertyReadBuilderListTileBuilder({
    required super.key,
    required this.item,
    required this.overrides,
  });

  @override
  Widget build(BuildContext context) {
    if (overrides.containsKey(item.id)) {
      return _DocumentPropertyReadBuilderListTile(
        key: ValueKey('DocumentProperty[${item.id}]ReadTile'),
        title: item.title,
        isMultiline: true,
        child: overrides[item.id]!(context, item),
      );
    }

    return switch (item) {
      DocumentLinkReadItem(:final title, :final value) => _DocumentPropertyReadBuilderListTile(
          key: ValueKey('DocumentProperty[${item.id}]ReadTile'),
          title: title,
          isMultiline: true,
          child: value != null ? LinkText(value) : const Text('-'),
        ),
      DocumentMarkdownListItem(:final title, :final value) => _DocumentPropertyReadBuilderListTile(
          key: ValueKey('DocumentProperty[${item.id}]ReadTile'),
          title: title,
          isMultiline: true,
          child: MarkdownText(value ?? const MarkdownData('-')),
        ),
      DocumentTextListItem(:final title, :final value, :final isMultiline) =>
        _DocumentPropertyReadBuilderListTile(
          key: ValueKey('DocumentProperty[${item.id}]ReadTile'),
          title: title,
          isMultiline: isMultiline,
          child: Text(value ?? '-'),
        ),
    };
  }
}

class _DocumentPropertyReadBuilderState extends State<DocumentPropertyReadBuilder> {
  final List<DocumentPropertyValueListItem<Object>> _items = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        for (final item in _items)
          _DocumentPropertyReadBuilderListTileBuilder(
            key: ObjectKey(item.id),
            item: item,
            overrides: widget.overrides,
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
  void didUpdateWidget(DocumentPropertyReadBuilder oldWidget) {
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
        for (final property
            in property.properties.whereNot((element) => element.schema.isSectionOrSubsection)) {
          yield* _calculateItemsFrom(property);
        }
      case DocumentObjectProperty():
        final schema = property.schema;
        switch (schema) {
          case DocumentSingleGroupedTagSelectorSchema():
            final value = schema.groupedTagsSelection(property);

            yield DocumentTextListItem(
              id: property.nodeId,
              title: '',
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
      case DocumentValueProperty<Object>():
        yield _mapDocumentPropertyToListItem(property);
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
          value: text,
        );
      case DocumentTokenValueCardanoAdaSchema():
        final num = schema.castValue(value);
        final text = num != null ? const Currency.ada().format(num) : null;

        return DocumentTextListItem(
          id: property.nodeId,
          title: schema.title,
          value: text,
        );
      case DocumentDurationInMonthsSchema():
        final months = schema.castValue(value);
        final text = months != null ? context.l10n.valueMonths(months) : null;

        return DocumentTextListItem(
          id: property.nodeId,
          title: schema.title,
          value: text,
        );
      case DocumentSingleLineHttpsUrlEntrySchema():
        final link = schema.castValue(value);

        return DocumentLinkReadItem(
          id: property.nodeId,
          title: schema.title,
          value: link,
        );
      case DocumentMultiLineTextEntrySchema():
        final text = schema.castValue(value);

        return DocumentTextListItem(
          id: property.nodeId,
          title: schema.title,
          value: text,
          isMultiline: true,
        );
      case DocumentMultiLineTextEntryMarkdownSchema():
        final text = schema.castValue(value);
        final data = text != null ? MarkdownData(text) : null;

        return DocumentMarkdownListItem(
          id: property.nodeId,
          title: schema.title,
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
          value: value?.toString(),
        );
    }
  }

  void _updateItems() {
    _items
      ..clear()
      ..addAll(_calculateItemsFrom(widget.property))
      ..removeWhere((element) => element.isEmpty);
  }
}
