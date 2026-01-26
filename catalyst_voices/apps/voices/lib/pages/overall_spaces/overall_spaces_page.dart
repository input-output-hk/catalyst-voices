import 'dart:async';

import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/pages/overall_spaces/back_fab.dart';
import 'package:catalyst_voices/pages/overall_spaces/brands_navigation.dart';
import 'package:catalyst_voices/pages/overall_spaces/spaces_overview_list_view.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class OverallSpacesPage extends StatefulWidget {
  const OverallSpacesPage({
    super.key,
  });

  @override
  State<OverallSpacesPage> createState() => _OverallSpacesPageState();
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
          Align(
            alignment: Alignment.centerLeft,
            child: BackFab(),
          ),
        ],
      ),
    );
  }
}

class _OverallSpacesPage extends StatelessWidget {
  const _OverallSpacesPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ).add(const EdgeInsets.only(bottom: 12, left: 16)),
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

class _OverallSpacesPageState extends State<OverallSpacesPage> {
  late final WorkspaceBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: const _OverallSpacesPage(),
    );
  }

  @override
  void dispose() {
    unawaited(_bloc.close());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final blocInstance = Dependencies.instance.get<WorkspaceBloc>();
    _bloc = blocInstance..add(const InitWorkspaceEvent());
  }
}
