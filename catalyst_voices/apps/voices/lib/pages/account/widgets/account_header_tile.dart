import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/ext/string_ext.dart';
import 'package:catalyst_voices/widgets/avatars/voices_avatar.dart';
import 'package:catalyst_voices/widgets/text/catalyst_id_text.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef _Data = ({String catalystId, String displayName});

class AccountHeaderTile extends StatelessWidget {
  const AccountHeaderTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, _Data>(
      selector: (state) {
        return (
          catalystId: state.account?.catalystId ?? '',
          displayName: state.account?.displayName ?? '',
        );
      },
      builder: (context, state) => _AccountHeaderTile(data: state),
    );
  }
}

class _AccountHeaderTile extends StatelessWidget {
  final _Data data;

  const _AccountHeaderTile({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VoicesAvatar(
          radius: 155 / 2,
          icon: Text(
            data.displayName.firstLetter?.capitalize() ?? '',
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
                data.displayName,
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.colors.textOnPrimaryLevel0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              CatalystIdText(
                data.catalystId,
                isCompact: false,
                backgroundColor: context.colors.onSurfaceNeutralOpaqueLv2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
