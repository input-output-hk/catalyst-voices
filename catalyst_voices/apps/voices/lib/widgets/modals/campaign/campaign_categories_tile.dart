import 'package:catalyst_voices/widgets/menu/voices_modal_menu.dart';
import 'package:catalyst_voices/widgets/tiles/voices_expansion_tile.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class CampaignCategoriesTile extends StatefulWidget {
  final List<CampaignSection> sections;

  const CampaignCategoriesTile({
    super.key,
    required this.sections,
  });

  @override
  State<CampaignCategoriesTile> createState() => _CampaignCategoriesTileState();
}

class _CampaignCategoriesTileState extends State<CampaignCategoriesTile> {
  String? _selectedSectionId;

  @override
  void initState() {
    super.initState();

    _selectedSectionId = widget.sections.firstOrNull?.id;
  }

  @override
  void didUpdateWidget(covariant CampaignCategoriesTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.sections != oldWidget.sections) {
      if (!widget.sections.any((element) => element.id == _selectedSectionId)) {
        _selectedSectionId = widget.sections.firstOrNull?.id;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedSection = widget.sections
        .singleWhereOrNull((element) => element.id == _selectedSectionId);

    return VoicesExpansionTile(
      initiallyExpanded: true,
      title: Text(context.l10n.campaignCategories),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Menu(
              selectedId: _selectedSectionId,
              menuItems: widget.sections,
              onTap: _updateSelection,
            ),
            const SizedBox(width: 32),
            Expanded(
              child: selectedSection != null
                  ? _Details(section: selectedSection)
                  : const SizedBox(),
            ),
          ],
        ),
      ],
    );
  }

  void _updateSelection(String id) {
    setState(() {
      _selectedSectionId = id;
    });
  }
}

class _Menu extends StatelessWidget {
  final String? selectedId;
  final List<MenuItem> menuItems;
  final ValueChanged<String> onTap;

  const _Menu({
    this.selectedId,
    required this.menuItems,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colors = theme.colors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          context.l10n.cardanoUseCases,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleSmall?.copyWith(
            color: colors.textOnPrimaryLevel0,
          ),
        ),
        const SizedBox(height: 12),
        VoicesModalMenu(
          selectedId: selectedId,
          menuItems: menuItems,
          onTap: onTap,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _Details extends StatelessWidget {
  final CampaignSection section;

  const _Details({
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colors = theme.colors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 48),
        Text(
          section.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.headlineMedium?.copyWith(
            color: colors.textOnPrimaryLevel1,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          section.title,
          style: textTheme.titleLarge?.copyWith(
            color: colors.textOnPrimaryLevel0,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          section.body,
          style: textTheme.bodyLarge?.copyWith(
            color: colors.textOnPrimaryLevel1,
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
