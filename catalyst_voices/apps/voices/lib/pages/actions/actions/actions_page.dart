import 'dart:async';

import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/pages/actions/actions/widgets/actions_page_content.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ActionsPage extends StatefulWidget {
  final ActionsPageTab tab;

  const ActionsPage({
    super.key,
    required this.tab,
  });

  @override
  State<ActionsPage> createState() => _ActionsPageState();
}

class _ActionsPageState extends State<ActionsPage> {
  late final MyActionsCubit _myActionsCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _myActionsCubit,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        child: ActionsPageContent(tab: widget.tab),
      ),
    );
  }

  @override
  void dispose() {
    unawaited(_myActionsCubit.close());

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _myActionsCubit = Dependencies.instance.get<MyActionsCubit>();
    unawaited(_myActionsCubit.init());
  }
}
