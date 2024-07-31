import 'package:catalyst_voices/widgets/app_bar/actions/voices_app_bar_actions.dart';
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
/// The [isNavVisible] parameter determines whether the navigation icon
/// (menu button) is visible. The [actions] parameter is a list of widgets to
/// display as actions in the app bar.
///
/// A set of possible actions widget are available in the actions subfolder.
class VoicesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isNavVisible;
  final List<Widget> actions;

  const VoicesAppBar({
    super.key,
    this.isNavVisible = true,
    this.actions = const [],
  });
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder<double>(
      xs: 8,
      other: 24,
      builder: (context, data) => AppBar(
        titleSpacing: data,
        toolbarHeight: 64,
        leadingWidth: 48 + data!,
        leading: isNavVisible
            ? Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8, left: data),
                child: IconButton(
                  color: Theme.of(context).colors.iconsForeground,
                  onPressed: () {
                    context
                        .findAncestorStateOfType<ScaffoldState>()
                        ?.openDrawer();
                  },
                  icon: const Icon(CatalystVoicesIcons.menu),
                ),
              )
            : null,
        title: Container(
          height: 64,
          alignment: Alignment.centerLeft,
          child: ResponsiveBuilder<({List<Widget> widgets, double itemGap})>(
            builder: (context, data) => ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) => data.widgets[index],
              separatorBuilder: (context, index) => SizedBox(
                width: data.itemGap,
              ),
              itemCount: data!.widgets.length,
              scrollDirection: Axis.horizontal,
            ),
            xs: (
              widgets: [
                CatalystSvgPicture.asset(
                  Theme.of(context).brandAssets.logoIcon.path,
                ),
              ],
              itemGap: 8
            ),
            sm: (
              widgets: [
                CatalystSvgPicture.asset(
                  Theme.of(context).brandAssets.logo.path,
                ),
                SearchButton(
                  onPressed: () {},
                ),
              ],
              itemGap: 16
            ),
            other: (
              widgets: [
                CatalystSvgPicture.asset(
                  Theme.of(context).brandAssets.logo.path,
                ),
                SearchButton(
                  onPressed: () {},
                ),
              ],
              itemGap: 24
            ),
          ),
        ),
        actions: [
          ResponsiveBuilder<({EdgeInsets wrapperPadding, double itemGap})>(
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
              padding: data!.wrapperPadding,
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemBuilder: (context, index) => actions[index],
                separatorBuilder: (context, index) => SizedBox(
                  width: data.itemGap,
                ),
                itemCount: actions.length,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
