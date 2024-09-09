import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class VoicesWorkspaceDrawer extends StatelessWidget {
  const VoicesWorkspaceDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesDrawer(
      children: [
        _Workspace(),
      ],
      bottom: VoicesDrawerSpaceChooser(
        currentSpace: Space.workspace,
        onChanged: (value) {},
      ),
    );
  }
}

class _Workspace extends StatefulWidget {
  const _Workspace();

  @override
  State<_Workspace> createState() => _WorkspaceState();
}

class _WorkspaceState extends State<_Workspace> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _WorkspaceHeader(
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
            title: Text('My private proposals (3/5)'),
          ),
          VoicesDrawerNavItem(
            name: 'My first proposal',
            status: ProposalStatus.draft,
          ),
          VoicesDrawerNavItem(
            name: 'My second proposal',
            status: ProposalStatus.inProgress,
          ),
          VoicesDrawerNavItem(
            name: 'My third proposal',
            status: ProposalStatus.inProgress,
          ),
        ],
      ],
    );
  }
}

class _WorkspaceHeader extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isExpanded;

  const _WorkspaceHeader({
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
              icon: Icon(CatalystVoicesIcons.briefcase),
              foregroundColor: theme.colors.iconsPrimary,
              backgroundColor: theme.colors.onSurfaceNeutral08,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Workspace',
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
