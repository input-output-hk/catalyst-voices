import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

class ProposalDocumentSectionTile extends StatefulWidget {
  final DocumentProperty property;

  const ProposalDocumentSectionTile({
    super.key,
    required this.property,
  });

  @override
  State<ProposalDocumentSectionTile> createState() {
    return _ProposalDocumentSectionTileState();
  }
}

class _DocumentPropertyValue extends StatelessWidget {
  final String title;
  final Widget value;
  final bool isMultiline;

  const _DocumentPropertyValue({
    required this.title,
    required this.value,
    this.isMultiline = false,
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
          child: value,
        ),
      ],
    );
  }
}

class _DocumentPropertyValueBuilder extends StatelessWidget {
  final DocumentValueProperty property;

  const _DocumentPropertyValueBuilder({
    required super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
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
            : '-';

        return _DocumentPropertyValue(
          title: schema.title,
          value: Text(text),
        );
      case DocumentTokenValueCardanoAdaSchema():
        final amount = schema.castValue(value);
        const currency = Currency.ada();
        return _DocumentPropertyValue(
          title: schema.title,
          value: Text(amount != null ? currency.format(amount) : '-'),
        );
      case DocumentDurationInMonthsSchema():
        final months = schema.castValue(value);
        return _DocumentPropertyValue(
          title: schema.title,
          value: Text(months != null ? context.l10n.valueMonths(months) : '-'),
        );
      case DocumentSingleLineHttpsUrlEntrySchema():
        final link = schema.castValue(value);

        return _DocumentPropertyValue(
          title: schema.title,
          value: link != null ? LinkText(link) : const Text('-'),
        );
      case DocumentMultiLineTextEntrySchema():
        final text = schema.castValue(value);

        return _DocumentPropertyValue(
          title: schema.title,
          value: Text(text ?? '-'),
          isMultiline: true,
        );
      case DocumentMultiLineTextEntryMarkdownSchema():
        final text = schema.castValue(value);
        final data = MarkdownData(text ?? '-');

        return _DocumentPropertyValue(
          title: schema.title,
          value: MarkdownText(data),
          isMultiline: true,
        );
      case DocumentTagGroupSchema():
      case DocumentTagSelectionSchema():
        return const Text('------- NOT IMPLEMENTED -------');
      case DocumentLanguageCodeSchema():
        final code = schema.castValue(value);
        final localeNames = LocaleNames.of(context);
        final name = code != null ? localeNames?.nameOf(code) : null;

        return _DocumentPropertyValue(
          title: schema.title,
          value: Text(name ?? '-'),
        );
      case DocumentDropDownSingleSelectSchema():
      case DocumentGenericIntegerSchema():
      case DocumentGenericNumberSchema():
      case DocumentSingleLineTextEntrySchema():
      case DocumentRadioButtonSelect():
      case DocumentGenericStringSchema():
        return _DocumentPropertyValue(
          title: schema.title,
          value: Text(value?.toString() ?? '-'),
        );
    }
  }
}

class _ProposalDocumentSectionTileState
    extends State<ProposalDocumentSectionTile> {
  final List<DocumentValueProperty> _valueProperties = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitleText(widget.property.schema.title),
          if (_valueProperties.length > 1) const SizedBox(height: 16),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _valueProperties
                // TODO(damian-molinski): singleLineHttpsURLEntryList
                .map<Widget>((property) {
                  return _DocumentPropertyValueBuilder(
                    key: ObjectKey(property.nodeId),
                    property: property,
                  );
                })
                .separatedBy(const SizedBox(height: 16))
                .toList(),
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(ProposalDocumentSectionTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.property != oldWidget.property) {
      _valueProperties
        ..clear()
        ..addAll(_expandValueProperties(widget.property));
    }
  }

  @override
  void initState() {
    super.initState();

    _valueProperties.addAll(_expandValueProperties(widget.property));
  }

  Iterable<DocumentValueProperty> _expandValueProperties(
    DocumentProperty property,
  ) sync* {
    switch (property) {
      case DocumentListProperty():
        for (final property in property.properties
            .whereNot((element) => element.schema.isSectionOrSubsection)) {
          yield* _expandValueProperties(property);
        }
      case DocumentObjectProperty():
        switch (property.schema) {
          case DocumentSingleGroupedTagSelectorSchema():
          case DocumentSegmentSchema():
          case DocumentSectionSchema():
          case DocumentNestedQuestionsSchema():
          case DocumentBorderGroupSchema():
          case DocumentGenericObjectSchema():
            for (final property in property.properties
                .whereNot((element) => element.schema.isSectionOrSubsection)) {
              yield* _expandValueProperties(property);
            }
        }
      case DocumentValueProperty<Object>():
        yield property;
    }
  }
}

class _SectionTitleText extends StatelessWidget {
  final String data;

  const _SectionTitleText(
    this.data,
  );

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: context.textTheme.titleMedium?.copyWith(
        color: context.colors.textOnPrimaryLevel0,
      ),
    );
  }
}
