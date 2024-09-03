import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class VoicesTreasuryDrawer extends StatelessWidget {
  const VoicesTreasuryDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesDrawer(
      children: [
        _Treasury(),
      ],
      bottom: VoicesDrawerSpaceChooser(
        currentSpace: Space.treasury,
        onChanged: (value) {},
      ),
    );
  }
}

class _Treasury extends StatefulWidget {
  const _Treasury();

  @override
  State<_Treasury> createState() => _TreasuryState();
}

class _TreasuryState extends State<_Treasury> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TreasuryHeader(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          isExpanded: _isExpanded,
        ),
        if (_isExpanded) ...[
          SectionHeader(
            leading: SizedBox(width: 12),
            title: Text('Individual private campaigns'),
          ),
          VoicesDrawerNavItem(
            name: 'Fund name 1',
            status: ProposalStatus.ready,
          ),
          VoicesDrawerNavItem(
            name: 'Campaign 1',
            status: ProposalStatus.draft,
          ),
          VoicesDrawerNavItem(
            name: 'What happens with a campaign title that is longer that',
            status: ProposalStatus.draft,
          ),
        ],
      ],
    );
  }
}

class _TreasuryHeader extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isExpanded;

  const _TreasuryHeader({
    this.onTap,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            EdgeInsets.symmetric(vertical: 14).add(EdgeInsets.only(left: 16)),
        child: Row(
          children: [
            VoicesAvatar(
              icon: Icon(CatalystVoicesIcons.cash),
              foregroundColor: theme.colors.iconsSuccess,
              backgroundColor: theme.colors.successContainer,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Treasury',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: theme.colors.textPrimary),
              ),
            ),
            ChevronExpandButton(
              isExpanded: isExpanded,
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }
}
