import 'package:catalyst_voices/common/ext/ext.dart';
import 'package:catalyst_voices/pages/campaign/admin_tools/campaign_admin_tools_dialog.dart';
import 'package:catalyst_voices/pages/campaign/details/widgets/campaign_management.dart';
import 'package:catalyst_voices/pages/spaces/appbar/spaces_theme_mode_switch.dart';
import 'package:catalyst_voices/pages/spaces/drawer/spaces_drawer.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpacesShellPage extends StatefulWidget {
  static final Map<Space, ShortcutActivator> _spacesShortcutsActivators = {
    Space.discovery: LogicalKeySet(
      LogicalKeyboardKey.control,
      LogicalKeyboardKey.digit1,
    ),
    Space.workspace: LogicalKeySet(
      LogicalKeyboardKey.control,
      LogicalKeyboardKey.digit2,
    ),
    Space.voting: LogicalKeySet(
      LogicalKeyboardKey.control,
      LogicalKeyboardKey.digit3,
    ),
    Space.fundedProjects: LogicalKeySet(
      LogicalKeyboardKey.control,
      LogicalKeyboardKey.digit4,
    ),
    Space.treasury: LogicalKeySet(
      LogicalKeyboardKey.control,
      LogicalKeyboardKey.keyT,
    ),
  };

  final Space space;
  final Widget child;

  const SpacesShellPage({
    super.key,
    required this.space,
    required this.child,
  });

  @override
  State<SpacesShellPage> createState() => _SpacesShellPageState();
}

class _SpacesShellPageState extends State<SpacesShellPage> {
  final GlobalKey _adminToolsKey = GlobalKey(debugLabel: 'admin_tools');
  bool _showAdminTools = false;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState,
        Map<Space, ShortcutActivator>>(
      selector: (state) {
        return switch (state) {
          ActiveAccountSessionState(:final spacesShortcuts) => spacesShortcuts,
          _ => {},
        };
      },
      builder: (context, shortcuts) {
        return CallbackShortcuts(
          bindings: <ShortcutActivator, VoidCallback>{
            for (final entry in shortcuts.entries)
              entry.value: () => entry.key.go(context),
            CampaignAdminToolsDialog.shortcut: _toggleCampaignAdminTools,
          },
          child: Stack(
            children: [
              BlocSelector<SessionCubit, SessionState,
                  ({bool isUnlocked, bool isVisitor})>(
                selector: (state) => (
                  isUnlocked: state is ActiveAccountSessionState,
                  isVisitor: state is VisitorSessionState
                ),
                builder: (context, state) {
                  return Scaffold(
                    appBar: VoicesAppBar(
                      leading:
                          state.isVisitor ? null : const DrawerToggleButton(),
                      automaticallyImplyLeading: false,
                      actions: _getActions(widget.space),
                    ),
                    drawer: state.isVisitor
                        ? null
                        : SpacesDrawer(
                            space: widget.space,
                            spacesShortcutsActivators:
                                SpacesShellPage._spacesShortcutsActivators,
                            isUnlocked: state.isUnlocked,
                          ),
                    body: widget.child,
                  );
                },
              ),
              if (_showAdminTools)
                DraggableCampaignAdminToolsDialog(
                  dialogKey: _adminToolsKey,
                  selectedSpace: widget.space,
                  onSpaceSelected: (space) => space.go(context),
                  onClose: _closeCampaignAdminTools,
                ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _getActions(Space space) {
    if (space == Space.treasury) {
      return [
        const CampaignManagement(),
        const SpacesThemeModeSwitch(),
      ];
    } else {
      return [
        const SpacesThemeModeSwitch(),
        const SessionActionHeader(),
        const SessionStateHeader(),
      ];
    }
  }

  void _toggleCampaignAdminTools() {
    setState(() {
      _showAdminTools = !_showAdminTools;
    });
  }

  void _closeCampaignAdminTools() {
    setState(() {
      _showAdminTools = false;
    });
  }
}
