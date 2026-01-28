import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

/// The loading placeholder for the proposal builder content
/// where actual properties will be rendered later when they are loaded.
class DocumentBuilderContentPlaceholder extends StatelessWidget {
  final bool show;

  const DocumentBuilderContentPlaceholder({
    super.key,
    required this.show,
  });

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !show,
      child: TickerMode(
        enabled: show,
        child: const _ContentPlaceholder(),
      ),
    );
  }
}

class _ContentPlaceholder extends StatelessWidget {
  const _ContentPlaceholder();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SizedBox(height: 12),
        _SectionHeaderPlaceholder(isOpen: true),
        SizedBox(height: 12),
        _SectionPlaceholder(),
        SizedBox(height: 12),
        _SectionPlaceholder(blocks: 3),
        SizedBox(height: 24),
        _SectionHeaderPlaceholder(isOpen: true),
        SizedBox(height: 12),
        _SectionPlaceholder(blocks: 2),
        SizedBox(height: 12),
        _SectionPlaceholder(blocks: 3),
      ],
    );
  }
}

class _SectionHeaderPlaceholder extends StatelessWidget {
  final bool isOpen;

  const _SectionHeaderPlaceholder({this.isOpen = false});

  @override
  Widget build(BuildContext context) {
    final icon = isOpen ? VoicesAssets.icons.chevronDown : VoicesAssets.icons.chevronRight;

    return Container(
      color: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        spacing: 12,
        children: [
          icon.buildIcon(color: Theme.of(context).colorScheme.onPrimary),
          _TextPlaceholder(
            width: 154,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ],
      ),
    );
  }
}

class _SectionPlaceholder extends StatelessWidget {
  final int blocks;

  const _SectionPlaceholder({this.blocks = 1});

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).colors.iconsDisabled.withAlpha(110);
    final subtitleColor = Theme.of(context).colors.iconsDisabled.withAlpha(40);
    final bodyColor = Theme.of(context).colors.iconsDisabled.withAlpha(20);

    return BaseTile(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _TextPlaceholder(color: titleColor),
            ),
            for (int i = 0; i < blocks; i++) ...[
              _TextPlaceholder(color: subtitleColor),
              _TextPlaceholder(
                color: bodyColor,
                width: double.infinity,
                height: 56,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TextPlaceholder extends StatelessWidget {
  final Color? color;
  final double width;
  final double height;

  const _TextPlaceholder({
    this.color,
    this.width = 110,
    this.height = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colors.iconsDisabled,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
