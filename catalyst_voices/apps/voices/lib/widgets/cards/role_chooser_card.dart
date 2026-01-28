import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

/// A role chooser card, responsible as a building block
/// for any role selection, and available in both
/// interactive and view-only mode.
class RoleChooserCard extends StatelessWidget {
  /// The current displaying value.
  final bool value;

  /// Icon image.
  final Widget icon;

  /// The text label displaying on the card.
  final String label;

  /// Whether can change [value]. This is different from [isViewOnly] as it
  /// does not affect UI
  final bool isLocked;

  /// Locks the value and shows it as default, only the selected value appears.
  final bool isDefault;

  /// Hides the "Learn More" link.
  final bool isLearnMoreHidden;

  /// Toggles view-only mode.
  final bool isViewOnly;

  /// Whether to display the value.
  final bool displayValue;

  /// A callback triggered when the role selection changes.
  final ValueChanged<bool>? onChanged;

  /// A callback triggered when the "Learn More" link is clicked.
  final VoidCallback? onLearnMore;

  const RoleChooserCard({
    super.key,
    required this.value,
    required this.icon,
    required this.label,
    this.isLocked = false,
    this.isDefault = false,
    this.isLearnMoreHidden = false,
    this.isViewOnly = false,
    this.displayValue = true,
    this.onChanged,
    this.onLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.all(isViewOnly ? 8 : 12),
      decoration: isViewOnly
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).colors.outlineBorderVariant),
              borderRadius: BorderRadius.circular(8),
            ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: displayValue ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [icon],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: displayValue ? MainAxisAlignment.start : MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
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
                      _LearnMoreText(onTap: onLearnMore),
                    ],
                  ],
                ),
                if (displayValue) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    child: isViewOnly
                        ? _DisplayingValueAsChips(value: value, isDefault: isDefault)
                        : _DisplayingValueAsSegmentedButton(
                            value: value,
                            isLocked: isLocked,
                            isDefault: isDefault,
                            onChanged: onChanged,
                          ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DisplayingValueAsChips extends StatelessWidget {
  final bool value;
  final bool isDefault;

  const _DisplayingValueAsChips({required this.value, required this.isDefault});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: [
        VoicesChip.round(
          content: Text(
            value ? context.l10n.yes : context.l10n.no,
            semanticsIdentifier: 'YesNoChip',
            style: TextStyle(
              color: value
                  ? Theme.of(context).colors.successContainer
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
        if (isDefault)
          VoicesChip.round(
            content: Text(
              context.l10n.defaultRole,
              semanticsIdentifier: 'DefaultRoleChip',
              style: TextStyle(color: Theme.of(context).colors.iconsPrimary),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            backgroundColor: Theme.of(context).colors.iconsBackgroundVariant,
          ),
      ],
    );
  }
}

class _DisplayingValueAsSegmentedButton extends StatelessWidget {
  final bool value;
  final bool isLocked;
  final bool isDefault;
  final ValueChanged<bool>? onChanged;

  const _DisplayingValueAsSegmentedButton({
    required this.value,
    required this.isLocked,
    required this.isDefault,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: VoicesSegmentedButton<bool>(
        segments: isLocked
            ? [
                ButtonSegment(
                  value: value,
                  label: Text(
                    [
                      if (value) context.l10n.yes else context.l10n.no,
                      if (isDefault) '(${context.l10n.defaultRole})',
                    ].join(' '),
                  ),
                  icon: Icon(value ? Icons.check : Icons.block),
                ),
              ]
            : [
                ButtonSegment(
                  value: true,
                  label: Text(context.l10n.yes, semanticsIdentifier: 'RoleYesButton'),
                  icon: value ? const Icon(Icons.check) : null,
                ),
                ButtonSegment(
                  value: false,
                  label: Text(context.l10n.no, semanticsIdentifier: 'RoleNoButton'),
                  icon: !value ? const Icon(Icons.block) : null,
                ),
              ],
        style: SegmentedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colors.textOnPrimary,
          selectedForegroundColor: value
              ? Theme.of(context).colors.successContainer
              : Theme.of(context).colors.errorContainer,
          selectedBackgroundColor: value
              ? Theme.of(context).colors.success
              : Theme.of(context).colors.iconsError,
          iconColor: value ? Theme.of(context).colors.successContainer : Colors.transparent,
        ),
        showSelectedIcon: false,
        selected: {value},
        onChanged: (selected) => onChanged?.call(selected.first),
      ),
    );
  }
}

class _LearnMoreText extends StatelessWidget {
  final VoidCallback? onTap;

  const _LearnMoreText({this.onTap});

  @override
  Widget build(BuildContext context) {
    return LinkText(
      context.l10n.learnMore,
      onTap: onTap,
      style: Theme.of(context).textTheme.labelMedium,
      underline: false,
    );
  }
}
