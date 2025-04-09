import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountHeaderTile extends StatelessWidget {
  const AccountHeaderTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, CatalystId?>(
      selector: (state) => state.account?.catalystId,
      builder: (context, state) => _AccountHeaderTile(data: state),
    );
  }
}

class _AccountHeaderTile extends StatelessWidget {
  final CatalystId? data;

  const _AccountHeaderTile({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final data = this.data;

    return Row(
      children: [
        ProfileAvatar(
          key: const Key('AccountAvatar'),
          size: 155,
          username: data?.username,
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data?.username ?? '',
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.colors.textOnPrimaryLevel0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (data != null) ...[
                const SizedBox(height: 16),
                CatalystIdText(
                  data,
                  isCompact: false,
                  backgroundColor: context.colors.onSurfaceNeutralOpaqueLv2,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
