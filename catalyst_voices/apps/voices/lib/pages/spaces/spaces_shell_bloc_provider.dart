import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class SpacesShellBlocProvider extends StatelessWidget {
  final Widget child;

  const SpacesShellBlocProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VotingCubit>(
          create: (_) => Dependencies.instance.get<VotingCubit>(),
        ),
        BlocProvider<WorkspaceBloc>(
          create: (context) => Dependencies.instance.get<WorkspaceBloc>(),
        ),
        BlocProvider<DiscoveryCubit>(
          create: (context) => Dependencies.instance.get<DiscoveryCubit>(),
        ),
      ],
      child: child,
    );
  }
}
