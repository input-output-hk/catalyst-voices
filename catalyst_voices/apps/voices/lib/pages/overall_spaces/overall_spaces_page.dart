import 'package:catalyst_voices/pages/overall_spaces/back_fab.dart';
import 'package:catalyst_voices/pages/overall_spaces/brands_navigation.dart';
import 'package:catalyst_voices/pages/overall_spaces/spaces_overview_list_view.dart';
import 'package:catalyst_voices/pages/overall_spaces/update_ready.dart';
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
            .add(const EdgeInsets.only(bottom: 12, left: 16)),
        child: const Row(
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
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 200),
      child: const Column(
        children: [
          BrandsNavigation(),
          Spacer(),
          UpdateReady(),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: BackFab(),
          ),
        ],
      ),
    );
  }
}
