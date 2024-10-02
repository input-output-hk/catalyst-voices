import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

/// A constant grayscale [ColorFilter] used to de-saturate an image.
const _grayscaleFilter = ColorFilter.matrix([
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
]);

/// A role chooser card, responsible as a building block
/// for any role selection, and available in both
/// interactive and view-only mode.
class RoleChooserCard extends StatelessWidget {
  /// The current displaying value.
  final bool value;

  /// Needs to be a rasterized image.
  final String imageUrl;

  /// The text label displaying on the card.
  final String label;

  /// Locks the value and shows it as default, only the selected value appears.
  final bool lockValueAsDefault;

  /// Hides the "Learn More" link.
  final bool isLearnMoreHidden;

  /// Toggles view-only mode.
  final bool isViewOnly;

  /// A callback triggered when the role selection changes.
  final ValueChanged<bool>? onChanged;

  /// A callback triggered when the "Learn More" link is clicked.
  final VoidCallback? onLearnMore;

  const RoleChooserCard({
    super.key,
    required this.value,
    required this.imageUrl,
    required this.label,
    this.lockValueAsDefault = false,
    this.isLearnMoreHidden = false,
    this.isViewOnly = false,
    this.onChanged,
    this.onLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: isViewOnly
          ? null
          : BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colors.outlineBorderVariant!,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
      child: Padding(
        padding: EdgeInsets.all(isViewOnly ? 8 : 12),
        child: Row(
          children: [
            Column(
              children: [
                ColorFiltered(
                  colorFilter: _grayscaleFilter,
                  child: CatalystImage.asset(
                    imageUrl,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          label,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      if (!isLearnMoreHidden) ...[
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: onLearnMore,
                          child: Text(
                            context.l10n.learnMore,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  color: Theme.of(context).colors.iconsPrimary,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (isViewOnly)
                        Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: [
                            VoicesChip.round(
                              content: Text(
                                value ? context.l10n.yes : context.l10n.no,
                                style: TextStyle(
                                  color: value
                                      ? Theme.of(context)
                                          .colors
                                          .successContainer
                                      : Theme.of(context).colors.errorContainer,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              backgroundColor: value
                                  ? Theme.of(context).colors.success
                                  : Theme.of(context).colors.iconsError,
                            ),
                            if (lockValueAsDefault)
                              VoicesChip.round(
                                content: Text(
                                  context.l10n.defaultRole,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colors.iconsPrimary,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 4,
                                ),
                                backgroundColor:
                                    Theme.of(context).colors.iconsForeground,
                              ),
                          ],
                        )
                      else
                        Expanded(
                          child: VoicesSegmentedButton<bool>(
                            segments: lockValueAsDefault
                                ? [
                                    ButtonSegment(
                                      value: value,
                                      label: Text(
                                        [
                                          if (value)
                                            context.l10n.yes
                                          else
                                            context.l10n.no,
                                          '(${context.l10n.defaultRole})',
                                        ].join(' '),
                                      ),
                                      icon: Icon(
                                        value ? Icons.check : Icons.block,
                                      ),
                                    ),
                                  ]
                                : [
                                    ButtonSegment(
                                      value: true,
                                      label: Text(context.l10n.yes),
                                      icon: value
                                          ? const Icon(Icons.check)
                                          : null,
                                    ),
                                    ButtonSegment(
                                      value: false,
                                      label: Text(context.l10n.no),
                                      icon: !value
                                          ? const Icon(Icons.block)
                                          : null,
                                    ),
                                  ],
                            style: SegmentedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor:
                                  Theme.of(context).colors.textOnPrimary,
                              selectedForegroundColor: value
                                  ? Theme.of(context).colors.successContainer
                                  : Theme.of(context).colors.errorContainer,
                              selectedBackgroundColor: value
                                  ? Theme.of(context).colors.success
                                  : Theme.of(context).colors.iconsError,
                            ),
                            showSelectedIcon: false,
                            selected: {value},
                            onChanged: (selected) =>
                                onChanged?.call(selected.first),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
