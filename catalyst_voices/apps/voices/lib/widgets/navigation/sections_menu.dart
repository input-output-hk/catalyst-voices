import 'package:catalyst_voices/widgets/menu/voices_node_menu.dart';
import 'package:catalyst_voices/widgets/navigation/sections_controller.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class SectionsMenuListener extends StatelessWidget {
  final SectionsController controller;

  const SectionsMenuListener({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, _) {
        return SectionsMenu(
          sections: value.sections,
          openedSections: value.openedSections,
          selectedStep: value.selectedStep,
          onSectionTap: controller.toggleSection,
          onStepSelected: controller.selectSectionStep,
        );
      },
    );
  }
}

class SectionsMenu extends StatelessWidget {
  final List<Section> sections;
  final Set<int> openedSections;
  final SectionStepId? selectedStep;
  final ValueChanged<int> onSectionTap;
  final ValueChanged<SectionStepId> onStepSelected;

  const SectionsMenu({
    super.key,
    required this.sections,
    this.openedSections = const {},
    this.selectedStep,
    required this.onSectionTap,
    required this.onStepSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: sections.map(
        (section) {
          return VoicesNodeMenu(
            key: ValueKey('Section[${section.id}]NodeMenu'),
            name: section.localizedName(context),
            icon: section.icon.buildIcon(),
            onHeaderTap: () {
              onSectionTap(section.id);
            },
            onItemTap: (stepId) {
              onStepSelected((sectionId: section.id, stepId: stepId));
            },
            selectedItemId: selectedStep?.sectionId == section.id
                ? selectedStep?.stepId
                : null,
            isExpanded: openedSections.contains(section.id),
            items: section.steps.map(
              (step) {
                return VoicesNodeMenuItem(
                  id: step.id,
                  label: step.localizedName(context),
                  isEnabled: step.isEnabled,
                );
              },
            ).toList(),
          );
        },
      ).toList(),
    );
  }
}
