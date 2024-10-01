import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class RoleChooserCard extends StatelessWidget {
  final String imageUrl;
  final bool value;
  final String label;
  final bool lockValueAsDefault;
  final bool isLearnMoreHidden;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onLearnMore;

  const RoleChooserCard({
    super.key,
    required this.imageUrl,
    required this.value,
    required this.label,
    this.lockValueAsDefault = false,
    this.isLearnMoreHidden = false,
    this.onChanged,
    this.onLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colors.outlineBorderVariant!,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Column(
              children: [
                CatalystImage.asset(
                  imageUrl,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
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
                          child: FocusableActionDetector(
                            mouseCursor: SystemMouseCursors.click,
                            child: Text(
                              context.l10n.learnMore,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colors.iconsPrimary,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: VoicesSegmentedButton<bool>(
                          segments: lockValueAsDefault
                              ? [
                                  ButtonSegment(
                                    value: value,
                                    label: value
                                        ? Text(
                                            [
                                              context.l10n.yes,
                                              '(${context.l10n.defaultRole})',
                                            ].join(' '),
                                          )
                                        : Text(
                                            [
                                              context.l10n.no,
                                              '(${context.l10n.defaultRole})',
                                            ].join(' '),
                                          ),
                                    icon: value
                                        ? const Icon(Icons.check)
                                        : const Icon(Icons.block),
                                  ),
                                ]
                              : [
                                  ButtonSegment(
                                    value: true,
                                    label: Text(context.l10n.yes),
                                    icon:
                                        value ? const Icon(Icons.check) : null,
                                  ),
                                  ButtonSegment(
                                    value: false,
                                    label: Text(context.l10n.no),
                                    icon:
                                        !value ? const Icon(Icons.block) : null,
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
                          onChanged: (selected) => onChanged
                              ?.call(lockValueAsDefault ? value : !value),
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
