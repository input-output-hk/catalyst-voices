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
    return BlocSelector<SessionCubit, SessionState, String?>(
      selector: (state) => state.account?.username,
      builder: (context, state) {
        return ProfileAvatar(
          size: 40,
          username: state,
          onTap: onTap,
        );
      },
    );
  }
}
