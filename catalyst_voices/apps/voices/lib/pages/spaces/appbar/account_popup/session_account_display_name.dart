import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class SessionAccountDisplayName extends StatelessWidget {
  const SessionAccountDisplayName({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, String?>(
      selector: (state) => state.account?.username,
      builder: (context, state) => _Text(state),
    );
  }
}

class _Text extends StatelessWidget {
  final String? data;

  const _Text(this.data);

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textTheme.titleMedium?.copyWith(
      color: context.colors.textOnPrimaryLevel0,
    );

    return UsernameText(
      data,
      style: textStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
