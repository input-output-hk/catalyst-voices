import 'package:catalyst_voices/widgets/menu/voices_modal_menu.dart';
import 'package:catalyst_voices/widgets/tiles/voices_expansion_tile.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class CampaignCategoriesTile extends StatefulWidget {
  const CampaignCategoriesTile({
    super.key,
  });

  @override
  State<CampaignCategoriesTile> createState() => _CampaignCategoriesTileState();
}

class _CampaignCategoriesTileState extends State<CampaignCategoriesTile> {
  @override
  Widget build(BuildContext context) {
    return VoicesExpansionTile(
      initiallyExpanded: true,
      title: Text('Campaign Categories'),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Menu(),
            SizedBox(width: 32),
            Expanded(child: _Details()),
          ],
        ),
      ],
    );
  }
}

class _Menu extends StatelessWidget {
  const _Menu();

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
          'Cardano Use Cases',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleSmall?.copyWith(
            color: colors.textOnPrimaryLevel0,
          ),
        ),
        const SizedBox(height: 12),
        VoicesModalMenu(
          selectedId: '1',
          menuItems: [
            ModalMenuItem(id: '1', label: 'Concept'),
            ModalMenuItem(id: '2', label: 'Product'),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _Details extends StatelessWidget {
  const _Details();

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
          'Concept',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.headlineMedium?.copyWith(
            color: colors.textOnPrimaryLevel1,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Section Title',
          style: textTheme.titleLarge?.copyWith(
            color: colors.textOnPrimaryLevel0,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum '
          'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum '
          'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum '
          'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum '
          'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum '
          'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum',
          style: textTheme.bodyLarge?.copyWith(
            color: colors.textOnPrimaryLevel1,
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
