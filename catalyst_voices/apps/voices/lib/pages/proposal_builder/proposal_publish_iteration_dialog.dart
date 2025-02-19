import 'package:catalyst_voices/widgets/painter/arrow_right_painter.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

/// A dialog for publishing a new iteration of a proposal.
///
/// It supports publishing an iteration for the first time,
/// then [currentVersion] must be null.
/// For the next iterations the [currentVersion] is not null.
class ProposalPublishIterationDialog extends StatelessWidget {
  final String proposalTitle;
  final String? currentVersion;
  final String nextVersion;
  final VoidCallback onPublish;

  const ProposalPublishIterationDialog({
    super.key,
    required this.proposalTitle,
    required this.currentVersion,
    required this.nextVersion,
    required this.onPublish,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesSinglePaneDialog(
      constraints: const BoxConstraints(
        minWidth: 450,
        maxWidth: 450,
        minHeight: 256,
      ),
      showClose: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          const _Header(),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 28),
          _VersionUpdateSection(
            proposalTitle: proposalTitle,
            currentVersion: currentVersion,
            nextVersion: nextVersion,
          ),
          const SizedBox(height: 28),
          const Divider(),
          const SizedBox(height: 8),
          const _ListItems(),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          _Buttons(onPublish: onPublish),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  static Future<void> show({
    required BuildContext context,
    required String proposalTitle,
    required String? currentVersion,
    required String nextVersion,
    required VoidCallback onPublish,
  }) {
    return VoicesDialog.show(
      context: context,
      routeSettings: const RouteSettings(name: '/publish-proposal-iteration'),
      builder: (context) => ProposalPublishIterationDialog(
        proposalTitle: proposalTitle,
        currentVersion: currentVersion,
        nextVersion: nextVersion,
        onPublish: onPublish,
      ),
      barrierDismissible: false,
    );
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 24),
      painter: ArrowRightPainter(
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  final VoidCallback onPublish;

  const _Buttons({required this.onPublish});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 16,
        children: [
          VoicesTextButton(
            onTap: () => Navigator.of(context).pop(),
            child: Text(context.l10n.cancelButtonText),
          ),
          VoicesTextButton(
            onTap: onPublish,
            child: Text(context.l10n.publishButtonText),
          ),
        ],
      ),
    );
  }
}

class _DraftChip extends StatelessWidget {
  const _DraftChip();

  @override
  Widget build(BuildContext context) {
    return VoicesChip.rectangular(
      content: Text(
        context.l10n.draft,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      backgroundColor: Theme.of(context).colors.iconsSecondary,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.publishNewProposalIterationDialogTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.publishNewProposalIterationDialogSubtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final SvgGenImage icon;
  final String text;

  const _ListItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 24,
      children: [
        icon.buildIcon(size: 24),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _ListItems extends StatelessWidget {
  const _ListItems();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ListItem(
            icon: VoicesAssets.icons.eye,
            text: context.l10n.publishNewProposalIterationDialogList1,
          ),
          const SizedBox(height: 8),
          _ListItem(
            icon: VoicesAssets.icons.chatAlt2,
            text: context.l10n.publishNewProposalIterationDialogList2,
          ),
          const SizedBox(height: 8),
          _ListItem(
            icon: VoicesAssets.icons.exclamationCircle,
            text: context.l10n.publishNewProposalIterationDialogList3,
          ),
        ],
      ),
    );
  }
}

class _VersionChip extends StatelessWidget {
  final String version;

  const _VersionChip({
    required this.version,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesChip.rectangular(
      content: Row(
        children: [
          VoicesAssets.icons.documentText.buildIcon(size: 18),
          const SizedBox(width: 6),
          Text(
            version,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colors.textOnPrimaryLevel1,
                ),
          ),
        ],
      ),
    );
  }
}

class _VersionUpdate extends StatelessWidget {
  final String? current;
  final String next;

  const _VersionUpdate({
    required this.current,
    required this.next,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (current != null) ...[
          const _DraftChip(),
          const SizedBox(width: 4),
        ],
        _VersionChip(version: current ?? context.l10n.local),
        const SizedBox(width: 16),
        const Expanded(child: _Arrow()),
        const SizedBox(width: 16),
        const _DraftChip(),
        const SizedBox(width: 4),
        _VersionChip(version: next),
      ],
    );
  }
}

class _VersionUpdateSection extends StatelessWidget {
  final String proposalTitle;
  final String? currentVersion;
  final String nextVersion;

  const _VersionUpdateSection({
    required this.proposalTitle,
    required this.currentVersion,
    required this.nextVersion,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.change,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colors.textOnPrimaryLevel1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            proposalTitle,
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _VersionUpdate(
            current: currentVersion,
            next: nextVersion,
          ),
        ],
      ),
    );
  }
}
