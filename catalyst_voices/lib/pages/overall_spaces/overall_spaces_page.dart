import 'package:catalyst_voices/pages/overall_spaces/brands_navigation.dart';
import 'package:catalyst_voices/pages/overall_spaces/spaces_overview_list_view.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class OverallSpacesPage extends StatelessWidget {
  const OverallSpacesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16)
            .add(EdgeInsets.only(bottom: 12, left: 16)),
        child: Row(
          children: [
            _Navigation(),
            SizedBox(width: 16),
            Expanded(child: SpacesListView()),
          ],
        ),
      ),
    );
  }
}

class _Navigation extends StatelessWidget {
  const _Navigation();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BrandsNavigation(),
        Spacer(),
        FloatingActionButton(
          onPressed: () {},
          shape: CircleBorder(),
          child: Icon(CatalystVoicesIcons.arrow_left),
        )
      ],
    );
  }
}
