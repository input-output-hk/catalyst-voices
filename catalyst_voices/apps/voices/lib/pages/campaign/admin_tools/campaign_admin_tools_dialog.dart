import 'package:catalyst_voices/common/ext/space_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A draggable [CampaignAdminToolsDialog],
/// should be used as a child of a [Stack].
///
/// Initially shown at bottom-left corner with [initialPadding] offset.
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
  ///
  /// The widget should be used inside a stack so left/bottom properties
  /// from [EdgeInsets] correspond to left/bottom properties
  /// from the related [Positioned] widget.
  final EdgeInsets initialPadding;

  const DraggableCampaignAdminToolsDialog({
    super.key,
    required this.dialogKey,
    required this.selectedSpace,
    required this.onSpaceSelected,
    required this.onClose,
    this.initialPadding = const EdgeInsets.only(left: 32, bottom: 32),
  });

  @override
  State<DraggableCampaignAdminToolsDialog> createState() =>
      _DraggableCampaignAdminToolsDialogState();
}

class _DraggableCampaignAdminToolsDialogState
    extends State<DraggableCampaignAdminToolsDialog> {
  late Offset _position;
  late Size _screenSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _screenSize = MediaQuery.sizeOf(context);
    _position = Offset(
      widget.initialPadding.left,
      _screenSize.height -
          CampaignAdminToolsDialog._height -
          widget.initialPadding.bottom,
    );
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
    final clampedPosition = Offset(
      newPosition.dx.clamp(
        0,
        _screenSize.width - CampaignAdminToolsDialog._width,
      ),
      newPosition.dy.clamp(
        0,
        _screenSize.height - CampaignAdminToolsDialog._height,
      ),
    );

    if (_position != clampedPosition) {
      setState(() {
        _position = clampedPosition;
      });
    }
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
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            _Header(onClose: onClose),
            const Expanded(child: _Tabs()),
            const Divider(
              height: 0,
              indent: 0,
              endIndent: 0,
            ),
            _Footer(
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
                _EventsTab(),
                _ViewsTab(),
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

class _EventsTab extends StatelessWidget {
  const _EventsTab();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(child: _CampaignStatusChooser()),
        _EventTimelapseControls(),
      ],
    );
  }
}

class _CampaignStatusChooser extends StatelessWidget {
  const _CampaignStatusChooser();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1Grey,
      child: Column(
        children: [
          const SizedBox(height: 8),
          for (final status in CampaignStatus.values)
            // TODO(dtscalac): store active one somewhere
            _EventItem(
              status: status,
              isActive: status == CampaignStatus.draft,
              onTap: () {},
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _EventItem extends StatelessWidget {
  final CampaignStatus status;
  final bool isActive;
  final VoidCallback onTap;

  const _EventItem({
    required this.status,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colors.textOnPrimary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 24, 12),
        child: Row(
          children: [
            _icon.buildIcon(
              size: 24,
              color: color,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                _text(context.l10n),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: color,
                    ),
              ),
            ),
            if (isActive)
              Text(
                context.l10n.active.toUpperCase(),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      color: color,
                    ),
              ),
          ],
        ),
      ),
    );
  }

  SvgGenImage get _icon => switch (status) {
        CampaignStatus.draft => VoicesAssets.icons.clock,
        CampaignStatus.live => VoicesAssets.icons.flag,
        CampaignStatus.completed => VoicesAssets.icons.calendar,
      };

  String _text(VoicesLocalizations l10n) => switch (status) {
        CampaignStatus.draft => l10n.campaignPreviewEventBefore,
        CampaignStatus.live => l10n.campaignPreviewEventDuring,
        CampaignStatus.completed => l10n.campaignPreviewEventAfter,
      };
}

class _EventTimelapseControls extends StatelessWidget {
  const _EventTimelapseControls();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: VoicesTextButton(
              leading: VoicesAssets.icons.rewind.buildIcon(),
              child: Text(context.l10n.previous),
              // TODO(dtscalac): implement button action
              onTap: () {},
            ),
          ),
          Container(
            width: 60,
            height: 56,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1Grey,
            ),
            alignment: Alignment.center,
            // TODO(dtscalac): implement timer ticking
            child: const Text('-5s'),
          ),
          Expanded(
            child: VoicesTextButton(
              leading: VoicesAssets.icons.fastForward.buildIcon(),
              child: Text(context.l10n.next),
              // TODO(dtscalac): implement button action
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewsTab extends StatelessWidget {
  const _ViewsTab();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      color: Colors.blue,
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
    return Padding(
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
