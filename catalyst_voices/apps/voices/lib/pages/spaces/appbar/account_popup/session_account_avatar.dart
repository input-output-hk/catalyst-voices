import 'package:catalyst_voices/common/ext/string_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionAccountAvatar extends StatelessWidget {
  final VoidCallback? onTap;

  const SessionAccountAvatar({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, String>(
      selector: (state) {
        return state.account?.displayName.firstLetter?.capitalize() ?? '';
      },
      builder: (context, state) {
        return _Avatar(
          letter: state,
          onTap: onTap,
        );
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  final String letter;
  final VoidCallback? onTap;

  const _Avatar({
    required this.letter,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesAvatar(
      icon: Text(letter),
      radius: 20,
      onTap: onTap,
    );
  }
}
