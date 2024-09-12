import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class BrandsNavigation extends StatelessWidget {
  const BrandsNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tightFor(width: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1White,
      ),
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _BrandTile(
            Brand.catalyst,
            key: ObjectKey(Brand.catalyst),
            isCurrent: true,
            onTap: () {},
          ),
          VoicesDivider(
            height: 16,
            indent: 0,
            endIndent: 0,
          ),
          _SearchTile(),
          _TasksTile(),
        ],
      ),
    );
  }
}

class _BrandTile extends StatelessWidget {
  final Brand brandKey;
  final bool isCurrent;
  final VoidCallback? onTap;

  const _BrandTile(
    this.brandKey, {
    super.key,
    this.isCurrent = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _BrandsNavigationTile(
      onTap: onTap,
      isSelected: isCurrent,
      leading: Icon(CatalystVoicesIcons.search),
      content: Text('Search Brands'),
    );
  }
}

class _SearchTile extends StatelessWidget {
  final VoidCallback? onTap;

  const _SearchTile({
    // ignore: unused_element
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _BrandsNavigationTile(
      onTap: onTap,
      leading: Icon(CatalystVoicesIcons.search),
      content: Text('Search Brands'),
    );
  }
}

class _TasksTile extends StatelessWidget {
  final VoidCallback? onTap;

  const _TasksTile({
    // ignore: unused_element
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _BrandsNavigationTile(
      onTap: onTap,
      leading: Icon(CatalystVoicesIcons.collection),
      content: Text('Tasks'),
    );
  }
}

class _BrandsNavigationTile extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isSelected;
  final Widget leading;
  final Widget content;

  const _BrandsNavigationTile({
    this.onTap,
    this.isSelected = false,
    required this.leading,
    required this.content,
  });

  Set<WidgetState> get _states => {
        if (onTap == null) WidgetState.disabled,
        if (isSelected) WidgetState.selected,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final backgroundColor = _BackgroundColor(theme.colors);
    final foregroundColor = _ForegroundColor(theme.colors);

    final textStyle = (theme.textTheme.bodyLarge ?? TextStyle())
        .copyWith(color: foregroundColor.resolve(_states));

    final iconTheme = IconThemeData(
      size: 24,
      color: foregroundColor.resolve(_states),
    );

    return DefaultTextStyle(
      style: textStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      child: IconTheme(
        data: iconTheme,
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(height: 56),
          child: Material(
            textStyle: textStyle,
            color: backgroundColor.resolve(_states),
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    leading,
                    SizedBox(width: 12),
                    Expanded(child: content),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _BackgroundColor implements WidgetStateProperty<Color?> {
  final VoicesColorScheme colors;

  _BackgroundColor(this.colors);

  @override
  Color? resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return colors.onSurfacePrimaryContainer?.withOpacity(0.12);
    }

    return Colors.transparent;
  }
}

final class _ForegroundColor implements WidgetStateProperty<Color?> {
  final VoicesColorScheme colors;

  _ForegroundColor(this.colors);

  @override
  Color? resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return colors.textOnPrimaryLevel0?.withOpacity(0.3);
    }

    return colors.textOnPrimaryLevel0;
  }
}
