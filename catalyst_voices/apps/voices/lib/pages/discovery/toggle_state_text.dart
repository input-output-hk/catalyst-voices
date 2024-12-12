import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Note. This widget will be removed so its not localized
class ToggleStateText extends StatefulWidget {
  const ToggleStateText({
    super.key,
  });

  @override
  State<ToggleStateText> createState() => _ToggleStateTextState();
}

class _ToggleStateTextState extends State<ToggleStateText> {
  final _tapVisitor = TapGestureRecognizer();
  final _tapGuest = TapGestureRecognizer();
  final _tapActiveUser = TapGestureRecognizer();

  @override
  void initState() {
    super.initState();
    _tapVisitor.onTap = () async {
      await context.read<SessionCubit>().removeKeychain();
    };
    _tapGuest.onTap = () async {
      final sessionBloc = context.read<SessionCubit>();

      if (sessionBloc.state is ActiveAccountSessionState) {
        await sessionBloc.lock();
      } else if (sessionBloc.state is VisitorSessionState) {
        await sessionBloc
            .switchToDummyAccount()
            .then((_) => sessionBloc.lock());
      }
    };
    _tapActiveUser.onTap = () async {
      final sessionBloc = context.read<SessionCubit>();

      await sessionBloc
          .switchToDummyAccount()
          .then((_) => sessionBloc.unlock(SessionCubit.dummyUnlockFactor));
    };
  }

  @override
  void dispose() {
    _tapVisitor.dispose();
    _tapGuest.dispose();
    _tapActiveUser.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          key: const Key('VisitorShortcut'),
          onTap: _tapVisitor.onTap,
          child: const Text(
            'No key (visitor)',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.blue,
            ),
          ),
        ),
        const Text(', '),
        GestureDetector(
          key: const Key('GuestShortcut'),
          onTap: _tapGuest.onTap,
          child: const Text(
            'Key found(Guest/locked)',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.blue,
            ),
          ),
        ),
        const Text(', '),
        GestureDetector(
          key: const Key('UserShortcut'),
          onTap: _tapActiveUser.onTap,
          child: const Text(
            'Key found (Active user/unlocked)',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
