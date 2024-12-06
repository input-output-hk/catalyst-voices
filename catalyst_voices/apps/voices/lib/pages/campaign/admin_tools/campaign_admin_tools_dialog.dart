import 'package:catalyst_voices/common/ext/space_ext.dart';
import 'package:catalyst_voices/pages/campaign/admin_tools/campaign_admin_tools_events.dart';
import 'package:catalyst_voices/pages/campaign/admin_tools/campaign_admin_tools_views.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A draggable [CampaignAdminToolsDialog],
/// should be used as a child of a [Stack].
///
/// Initially shown at bottom-left corner with [initialOffset] offset.
class DraggableCampaignAdminToolsDialog extends StatefulWidget {
  /// The key for the [CampaignAdminToolsDialog] to make sure it's state
  /// is kept when a user keeps dragging it.
  ///
  /// The state might include currently open tab from [TabBar],
  /// scroll position, etc.
  final GlobalKey dialogKey;

  /// See [CampaignAdminToolsDialog.selectedSpace].
  final Space selectedSpace;

  /// See [CampaignAdminToolsDialog.onSpaceSelected].
  final ValueChanged<Space> onSpaceSelected;

  /// See [CampaignAdminToolsDialog.onClose].
  final VoidCallback onClose;

  /// The initial offset from bottom-left for the dialog.
  final Offset initialOffset;

  const DraggableCampaignAdminToolsDialog({
    super.key,
    required this.dialogKey,
    required this.selectedSpace,
    required this.onSpaceSelected,
    required this.onClose,
    this.initialOffset = const Offset(32, 32),
  });

  @override
  State<DraggableCampaignAdminToolsDialog> createState() =>
      _DraggableCampaignAdminToolsDialogState();
}

class _DraggableCampaignAdminToolsDialogState
    extends State<DraggableCampaignAdminToolsDialog> {
  Offset _position = Offset.infinite;
  late Size _screenSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _screenSize = MediaQuery.sizeOf(context);

    if (_position.isInfinite) {
      // initialize it for the first time
      _position = Offset(
        widget.initialOffset.dx,
        _screenSize.height -
            CampaignAdminToolsDialog._height -
            widget.initialOffset.dy,
      );
    } else {
      // clamp it so that it fits into the screen
      // in case user shrinks the app window

      _position = _clampIntoScreenBounds(_position);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = CampaignAdminToolsDialog(
      key: widget.dialogKey,
      selectedSpace: widget.selectedSpace,
      onSpaceSelected: widget.onSpaceSelected,
      onClose: widget.onClose,
    );

    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: Draggable(
        onDragUpdate: _onDragUpdate,
        childWhenDragging: const Offstage(),
        feedback: child,
        child: child,
      ),
    );
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final newPosition = _position + details.delta;
    final clampedPosition = _clampIntoScreenBounds(newPosition);

    if (_position != clampedPosition) {
      setState(() {
        _position = clampedPosition;
      });
    }
  }

  /// Makes sure the dialog would fit into a screen window
  /// even if the window gets shrunk, etc.
  Offset _clampIntoScreenBounds(Offset offset) {
    return Offset(
      offset.dx.clamp(
        0,
        _screenSize.width - CampaignAdminToolsDialog._width,
      ),
      offset.dy.clamp(
        0,
        _screenSize.height - CampaignAdminToolsDialog._height,
      ),
    );
  }
}

/// The campaign admin tools dialog which supports
/// mocking different campaign and user states.
///
/// With it you can mock the keychain, mock the
/// campaign state or quickly switch between states.
class CampaignAdminToolsDialog extends StatelessWidget {
  /// The keyboard shortcut to activate the admin tools.
  ///
  /// You must handle the shortcut in the parent widget,
  /// it is added here for convenience.
  static final ShortcutActivator shortcut = LogicalKeySet(
    LogicalKeyboardKey.control,
    LogicalKeyboardKey.shift,
    LogicalKeyboardKey.keyA,
  );

  static const double _width = 360;
  static const double _height = 480;

  /// The current selected [Space].
  /// Admin tools reuse the currently selected space from the navigation drawer.
  final Space selectedSpace;

  /// Callback to notify when [Space] changes.
  /// In response to this event the app should navigate to given space.
  final ValueChanged<Space> onSpaceSelected;

  /// Called when the user wants to close the admin tools.
  final VoidCallback onClose;

  const CampaignAdminToolsDialog({
    super.key,
    required this.selectedSpace,
    required this.onSpaceSelected,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1White,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colors.onSurfaceNeutral012!,
          width: 1,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            _Header(onClose: onClose),
            const Expanded(child: _Tabs()),
            _BlocFooter(
              selectedSpace: selectedSpace,
              onSpaceSelected: onSpaceSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onClose;

  const _Header({
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.l10n.campaignPreviewTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          XButton(onTap: onClose),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs();

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TabBar(),
          Expanded(
            child: TabBarStackView(
              children: [
                CampaignAdminToolsEventsTab(),
                CampaignAdminToolsViewsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar();

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabAlignment: TabAlignment.fill,
      indicatorSize: TabBarIndicatorSize.tab,
      tabs: [
        Tab(
          text: context.l10n.campaignPreviewEvents,
        ),
        Tab(
          text: context.l10n.campaignPreviewViews,
        ),
      ],
    );
  }
}

class _BlocFooter extends StatelessWidget {
  final Space selectedSpace;
  final ValueChanged<Space> onSpaceSelected;

  const _BlocFooter({
    required this.selectedSpace,
    required this.onSpaceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, List<Space>>(
      selector: (state) => state.spaces,
      builder: (context, spaces) {
        if (spaces.length <= 1) {
          // don't show footer with spaces if there's only once,
          // the user can't change it to anything else
          return const Offstage();
        }

        return _Footer(
          selectedSpace: selectedSpace,
          onSpaceSelected: onSpaceSelected,
        );
      },
    );
  }
}

class _Footer extends StatelessWidget {
  final Space selectedSpace;
  final ValueChanged<Space> onSpaceSelected;

  const _Footer({
    required this.selectedSpace,
    required this.onSpaceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(
          height: 0,
          indent: 0,
          endIndent: 0,
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (final space in Space.values)
                _SpaceItem(
                  space: space,
                  isActive: space == selectedSpace,
                  onTap: () => onSpaceSelected(space),
                ),
            ].separatedBy(const SizedBox(width: 8)).toList(),
          ),
        ),
      ],
    );
  }
}

class _SpaceItem extends StatelessWidget {
  final Space space;
  final bool isActive;
  final VoidCallback onTap;

  const _SpaceItem({
    required this.space,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesAvatar(
      icon: space.icon.buildIcon(),
      backgroundColor:
          isActive ? space.backgroundColor(context) : Colors.transparent,
      foregroundColor: isActive
          ? space.foregroundColor(context)
          : Theme.of(context).colors.iconsForeground,
      padding: const EdgeInsets.all(8),
      radius: 20,
      onTap: onTap,
    );
  }
}
