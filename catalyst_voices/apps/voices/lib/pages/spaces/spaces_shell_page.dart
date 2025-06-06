import 'dart:async';

import 'package:catalyst_voices/common/ext/space_ext.dart';
import 'package:catalyst_voices/pages/campaign/admin_tools/campaign_admin_tools_dialog.dart';
import 'package:catalyst_voices/pages/campaign/details/widgets/campaign_management.dart';
import 'package:catalyst_voices/pages/spaces/appbar/session_action_header.dart';
import 'package:catalyst_voices/pages/spaces/appbar/session_state_header.dart';
import 'package:catalyst_voices/pages/spaces/drawer/opportunities_drawer.dart';
import 'package:catalyst_voices/pages/spaces/drawer/spaces_drawer.dart';
import 'package:catalyst_voices/widgets/buttons/create_proposal_button.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef _SessionStateData = ({bool isActive, bool isProposer});

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

class _Shortcuts extends StatelessWidget {
  final VoidCallback onToggleAdminTools;
  final Widget child;

  const _Shortcuts({
    required this.onToggleAdminTools,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, Map<Space, ShortcutActivator>>(
      selector: (state) => state.spacesShortcuts,
      builder: (context, shortcuts) {
        return CallbackShortcuts(
          bindings: <ShortcutActivator, VoidCallback>{
            for (final entry in shortcuts.entries) entry.value: () => entry.key.go(context),
            if (kDebugMode) CampaignAdminToolsDialog.shortcut: onToggleAdminTools,
          },
          child: child,
        );
      },
    );
  }
}

class _SpacesShellPageState extends State<SpacesShellPage> {
  final GlobalKey _adminToolsKey = GlobalKey(debugLabel: 'admin_tools');
  final StreamController<Space> _selectedSpaceSC = StreamController.broadcast();
  OverlayEntry? _adminToolsOverlay;

  Stream<Space> get _watchSpace async* {
    yield widget.space;
    yield* _selectedSpaceSC.stream;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminToolsCubit, AdminToolsState>(
      listenWhen: (previous, current) => previous.enabled != current.enabled,
      listener: (context, state) {
        if (state.enabled) {
          _insertAdminToolsOverlay();
        } else {
          _removeAdminToolsOverlay();
        }
      },
      child: _Shortcuts(
        onToggleAdminTools: _toggleAdminTools,
        child: BlocSelector<SessionCubit, SessionState, _SessionStateData>(
          selector: (state) =>
              (isActive: state.isActive, isProposer: state.account?.isProposer ?? false),
          builder: (context, state) {
            return Scaffold(
              appBar: VoicesAppBar(
                leading: state.isActive ? const DrawerToggleButton() : null,
                automaticallyImplyLeading: false,
                actions: _getActions(widget.space, state.isProposer),
              ),
              drawer: state.isActive
                  ? SpacesDrawer(
                      space: widget.space,
                      spacesShortcutsActivators: SpacesShellPage._spacesShortcutsActivators,
                      isUnlocked: state.isActive,
                    )
                  : null,
              endDrawer: const OpportunitiesDrawer(),
              body: widget.child,
            );
          },
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(SpacesShellPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.space != widget.space) {
      _selectedSpaceSC.add(widget.space);
    }
  }

  @override
  void dispose() {
    _removeAdminToolsOverlay();
    unawaited(_selectedSpaceSC.close());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<WorkspaceBloc>().add(const WatchUserProposalsEvent());
  }

  OverlayEntry _createAdminToolsOverlay() {
    return OverlayEntry(
      builder: (BuildContext context) {
        return StreamBuilder<Space>(
          // Passing it as a stream, not as a value because when the page
          // rebuilds the overlay entry is not rebuilt.
          stream: _watchSpace,
          builder: (context, snapshot) {
            final space = snapshot.data;
            if (space == null) {
              return const Offstage();
            }

            return DraggableCampaignAdminToolsDialog(
              dialogKey: _adminToolsKey,
              selectedSpace: space,
              onSpaceSelected: (space) => space.go(context),
            );
          },
        );
      },
    );
  }

  List<Widget> _getActions(Space space, bool isProposer) {
    if (space == Space.treasury) {
      return const [
        CampaignManagement(),
      ];
    } else {
      return [
        if (space == Space.discovery && isProposer) const CreateProposalButton(),
        const SessionActionHeader(),
        const SessionStateHeader(),
      ];
    }
  }

  void _insertAdminToolsOverlay() {
    if (_adminToolsOverlay != null) {
      // already shown
      return;
    }

    final overlayEntry = _createAdminToolsOverlay();
    Overlay.of(context, rootOverlay: true).insert(overlayEntry);
    _adminToolsOverlay = overlayEntry;
  }

  void _removeAdminToolsOverlay() {
    _adminToolsOverlay?.remove();
    _adminToolsOverlay = null;
  }

  void _toggleAdminTools() {
    final cubit = context.read<AdminToolsCubit>();
    if (cubit.state.enabled) {
      cubit.disable();
    } else {
      cubit.enable();
    }
  }
}
