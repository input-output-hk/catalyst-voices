import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

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

class _DocumentValuePropertyWidget extends StatelessWidget {
  final DocumentValueProperty property;

  const _DocumentValuePropertyWidget({
    required super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;

    final title = property.schema.title;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodySmall?.copyWith(
            color: colors.textOnPrimaryLevel1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          property.value?.toString() ?? '-',
          style: textTheme.bodyMedium?.copyWith(
            color: colors.textOnPrimaryLevel0,
          ),
        ),
      ],
    );
  }
}

class _ProposalDocumentSectionTileState
    extends State<ProposalDocumentSectionTile> {
  final List<DocumentValueProperty> _valueProperties = [];

  @override
  Widget build(BuildContext context) {
    final children = _valueProperties.map<Widget>((property) {
      return _DocumentValuePropertyWidget(
        key: ObjectKey(property.nodeId),
        property: property,
      );
    });

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitleText(widget.property.schema.title),
          ...children,
        ].separatedBy(const SizedBox(height: 16)).toList(),
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
