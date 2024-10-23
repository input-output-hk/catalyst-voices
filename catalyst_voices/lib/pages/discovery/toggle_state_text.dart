import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
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
      }

      if (sessionBloc.state is VisitorSessionState) {
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
    final theme = Theme.of(context);

    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(text: 'Toggle between'),
          const TextSpan(text: ', '),
          TextSpan(
            text: 'No key (visitor)',
            style: const TextStyle(decoration: TextDecoration.underline),
            recognizer: _tapVisitor,
          ),
          const TextSpan(text: ', '),
          TextSpan(
            text: 'Key found(Guest/locked)',
            style: const TextStyle(decoration: TextDecoration.underline),
            recognizer: _tapGuest,
          ),
          const TextSpan(text: ', '),
          TextSpan(
            text: 'Key found (Active user/unlocked)',
            style: const TextStyle(decoration: TextDecoration.underline),
            recognizer: _tapActiveUser,
          ),
        ],
      ),
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colors.textOnPrimary,
      ),
    );
  }
}
