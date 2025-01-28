import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Note. This widget will be removed so its not localized
class CurrentUserStatusText extends StatelessWidget {
  const CurrentUserStatusText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sessionBloc = context.watch<SessionCubit>();

    final stateDesc = switch (sessionBloc.state.status) {
      SessionStatus.visitor => 'Visitor / no key',
      SessionStatus.guest => 'Guest / locked',
      SessionStatus.actor => 'Actor / unlocked',
    };

    return Text(
      'Segment $stateDesc',
      style: theme.textTheme.titleLarge?.copyWith(
        color: theme.colors.textOnPrimary,
      ),
    );
  }
}
