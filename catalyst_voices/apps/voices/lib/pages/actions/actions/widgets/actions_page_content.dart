import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/pages/actions/actions/widgets/action_cards_list.dart';
import 'package:catalyst_voices/pages/actions/actions/widgets/actions_header_text.dart';
import 'package:catalyst_voices/pages/actions/actions/widgets/actions_tabs_group.dart';
import 'package:catalyst_voices/pages/actions/actions_shell_page.dart';
import 'package:catalyst_voices/routes/routing/actions_route.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer_header.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ActionsPageContent extends StatefulWidget {
  final ActionsPageTab tab;

  const ActionsPageContent({super.key, required this.tab});

  @override
  State<ActionsPageContent> createState() => _ActionsPageContentState();
}

class _ActionsPageContentState extends State<ActionsPageContent>
    with SignalHandlerStateMixin<MyActionsCubit, MyActionsSignal, ActionsPageContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        VoicesDrawerHeader(
          text: context.l10n.myActions,
          onCloseTap: () => ActionsShellPage.close(context),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20,
            children: [
              const ActionsHeaderText(),
              ActionsTabsGroup(
                selectedTab: widget.tab,
                onChanged: _onTabChanged,
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    ActionCardsList(selectedTab: widget.tab),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(ActionsPageContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.tab != widget.tab) {
      context.read<MyActionsCubit>().updatePageTab(widget.tab);
    }
  }

  @override
  void handleSignal(MyActionsSignal signal) {
    switch (signal) {
      case ChangeTabMyActionsSignal(:final tab):
        _updateRoute(tab);
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<MyActionsCubit>().updatePageTab(widget.tab);
  }

  void _onTabChanged(ActionsPageTab? tab) {
    if (tab != null) {
      context.read<MyActionsCubit>().updatePageTab(tab);
    }
  }

  void _updateRoute(ActionsPageTab tab) {
    Router.neglect(context, () {
      ActionsRoute(tab: tab.name).replace(context);
    });
  }
}
