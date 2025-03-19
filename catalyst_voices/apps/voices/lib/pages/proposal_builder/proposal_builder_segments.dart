import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

part 'proposal_builder_document_widgets.dart';

final DocumentPropertyBuilderOverrides _widgetOverrides = {
  ProposalDocument.categoryDetailsNodeId: (context, property) =>
      _CategoryDetails(property: property),
};

class ProposalBuilderSegmentsSelector extends StatelessWidget {
  final ItemScrollController itemScrollController;

  const ProposalBuilderSegmentsSelector({
    super.key,
    required this.itemScrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalBuilderBloc, ProposalBuilderState, bool>(
      selector: (state) => state.showSegments,
      builder: (context, state) {
        return Offstage(
          offstage: !state,
          child: _ProposalBuilderSegments(
            itemScrollController: itemScrollController,
          ),
        );
      },
    );
  }
}

class _ProposalBuilderSegments extends StatelessWidget {
  final ItemScrollController itemScrollController;

  const _ProposalBuilderSegments({
    required this.itemScrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: SegmentsControllerScope.of(context),
      builder: (context, value, child) {
        final items = value.listItems;
        final selectedNodeId = value.activeSectionId;

        return SegmentsListView<DocumentSegment, DocumentSection>(
          itemScrollController: itemScrollController,
          items: items,
          padding: const EdgeInsets.only(top: 16, bottom: 64),
          sectionBuilder: (context, data) {
            return _Section(
              property: data.property,
              isSelected: data.property.nodeId == selectedNodeId,
            );
          },
        );
      },
    );
  }
}

class _Section extends StatelessWidget {
  final DocumentProperty property;
  final bool isSelected;

  const _Section({
    required this.property,
    required this.isSelected,
  });

  bool get _isEditable {
    for (final overriddenNodeId in _widgetOverrides.keys) {
      final sectionHasOverrides = overriddenNodeId.isChildOf(property.nodeId);
      if (sectionHasOverrides) {
        // disable editing for overridden widgets
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalBuilderBloc, ProposalBuilderState, bool>(
      selector: (state) => state.showValidationErrors,
      builder: (context, showValidationErrors) {
        return DocumentBuilderSectionTile(
          key: key,
          section: property,
          isSelected: isSelected,
          isEditable: _isEditable,
          autovalidateMode: showValidationErrors
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          onChanged: (value) {
            final event = SectionChangedEvent(changes: value);
            context.read<ProposalBuilderBloc>().add(event);
          },
          overrides: _widgetOverrides,
        );
      },
    );
  }
}
