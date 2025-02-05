import 'package:catalyst_voices/common/ext/ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class BrandsNavigation extends StatelessWidget {
  const BrandsNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1White,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ...Brand.values.map(
            (brand) {
              return _BrandTile(
                brand,
                key: ObjectKey(brand),
                onTap: () {},
              );
            },
          ),
          const VoicesDivider(
            height: 16,
            indent: 0,
            endIndent: 0,
          ),
          const _SearchTile(),
          const _TasksTile(),
        ],
      ),
    );
  }
}

class _BrandTile extends StatelessWidget {
  final Brand brand;
  final VoidCallback? onTap;

  const _BrandTile(
    this.brand, {
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCurrent = theme.brandAssets.brand == brand;

    return _BrandsNavigationTile(
      onTap: onTap,
      isSelected: isCurrent,
      leading: brand.logoIcon(context).buildIcon(allowColorFilter: false),
      content: Text(brand.localizedName(context.l10n)),
    );
  }
}

class _SearchTile extends StatelessWidget {
  const _SearchTile();

  @override
  Widget build(BuildContext context) {
    return _BrandsNavigationTile(
      leading: VoicesAssets.icons.search.buildIcon(),
      content: Text(context.l10n.overallSpacesSearchBrands),
    );
  }
}

class _TasksTile extends StatelessWidget {
  const _TasksTile();

  @override
  Widget build(BuildContext context) {
    return _BrandsNavigationTile(
      leading: VoicesAssets.icons.collection.buildIcon(),
      content: Text(context.l10n.overallSpacesTasks),
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

    final textStyle = (theme.textTheme.bodyLarge ?? const TextStyle())
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
          constraints: const BoxConstraints.tightFor(height: 56),
          child: Material(
            textStyle: textStyle,
            color: backgroundColor.resolve(_states),
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    leading,
                    const SizedBox(width: 12),
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
      return colors.onSurfacePrimaryContainer.withValues(alpha: 0.12);
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
      return colors.textOnPrimaryLevel0.withValues(alpha: 0.3);
    }

    return colors.textOnPrimaryLevel0;
  }
}
