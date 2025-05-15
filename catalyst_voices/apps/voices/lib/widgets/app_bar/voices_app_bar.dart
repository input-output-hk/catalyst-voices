import 'package:catalyst_voices/widgets/app_bar/actions/search_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_buttons.dart';
import 'package:catalyst_voices/widgets/separators/voices_divider.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

/// A custom [AppBar] widget that adapts to different screen sizes using the
/// [ResponsiveBuilder] class.
///
/// The [VoicesAppBar] implements the [PreferredSizeWidget] interface, making
/// it suitable for use as an app bar in a [Scaffold].
///
/// If has [Scaffold] parent with defined drawer automatically adds leading
/// toggle button. The [actions] parameter is a list of widgets to
/// display as actions in the app bar.
///
/// A set of possible actions widget are available in the actions subfolder.
class VoicesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final List<Widget> actions;
  final bool showSearch;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;

  const VoicesAppBar({
    super.key,
    this.leading,
    this.actions = const [],
    this.showSearch = false,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return _Theme(
      child: ResponsiveBuilder<double>(
        xs: 8,
        other: 16,
        builder: (context, spacing) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBar(
                titleSpacing: spacing,
                toolbarHeight: preferredSize.height - 1,
                leading: _buildLeading(context),
                leadingWidth: 48.0 + spacing,
                automaticallyImplyLeading: false,
                backgroundColor: backgroundColor,
                title: _Title(showSearch: showSearch),
                actions: [
                  _Actions(children: actions),
                ],
              ),
              const VoicesDivider.expanded(height: 1),
            ],
          );
        },
      ),
    );
  }

  // Has to be nullable, that's why this is a function.
  Widget? _buildLeading(BuildContext context) {
    final canImplyDrawerToggleButton = automaticallyImplyLeading &&
        (Scaffold.maybeOf(context)?.hasDrawer ?? false);

    final canImplyPopButton = automaticallyImplyLeading &&
        (Navigator.maybeOf(context)?.canPop() ?? false);

    final child = leading ??
        (canImplyDrawerToggleButton ? const DrawerToggleButton() : null) ??
        (canImplyPopButton ? const NavigationPopButton() : null);

    if (child == null) {
      return null;
    }

    return Align(
      alignment: Alignment.centerRight,
      child: child,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}

class _Theme extends StatelessWidget {
  final Widget child;

  const _Theme({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return IconButtonTheme(
      data: const IconButtonThemeData(
        style: ButtonStyle(
          fixedSize: WidgetStatePropertyAll(Size.square(48)),
        ),
      ),
      child: child,
    );
  }
}

class _Title extends StatelessWidget {
  final bool showSearch;

  const _Title({required this.showSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      alignment: Alignment.centerLeft,
      child: ResponsiveBuilder<({List<Widget> widgets, double itemGap})>(
        builder: (context, data) => ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) => data.widgets[index],
          separatorBuilder: (context, index) => SizedBox(
            width: data.itemGap,
          ),
          itemCount: data.widgets.length,
          scrollDirection: Axis.horizontal,
        ),
        xs: (
          widgets: [
            Theme.of(context)
                .brandAssets
                .brand
                .logoIcon(context)
                .buildPicture(),
          ],
          itemGap: 8
        ),
        sm: (
          widgets: [
            Theme.of(context).brandAssets.brand.logo(context).buildPicture(),
            if (showSearch)
              SearchButton(
                onPressed: () {},
              ),
          ],
          itemGap: 16
        ),
        other: (
          widgets: [
            Theme.of(context).brandAssets.brand.logo(context).buildPicture(),
            if (showSearch)
              SearchButton(
                onPressed: () {},
              ),
          ],
          itemGap: 24
        ),
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  final List<Widget> children;

  const _Actions({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder<({EdgeInsets wrapperPadding, double itemGap})>(
      xs: const (
        wrapperPadding: EdgeInsets.only(right: 8),
        itemGap: 6,
      ),
      sm: const (
        wrapperPadding: EdgeInsets.only(right: 16),
        itemGap: 6,
      ),
      other: const (
        wrapperPadding: EdgeInsets.only(right: 24),
        itemGap: 12,
      ),
      builder: (context, data) => Container(
        alignment: Alignment.centerRight,
        padding: data.wrapperPadding,
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemBuilder: (context, index) => children[index],
          separatorBuilder: (context, index) => SizedBox(
            width: data.itemGap,
          ),
          itemCount: children.length,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
