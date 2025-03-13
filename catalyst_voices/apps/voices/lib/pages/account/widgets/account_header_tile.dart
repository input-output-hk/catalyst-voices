import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/avatars/voices_avatar.dart';
import 'package:catalyst_voices/widgets/user/catalyst_id_text.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
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
        VoicesAvatar(
          radius: 155 / 2,
          icon: Text(
            data?.username?.firstLetter?.capitalize() ?? '',
            style: const TextStyle(
              fontSize: 92,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
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
